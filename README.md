## Makefile.d: A programming environment for multiple runtimes.

[![Build Status][build]](https://travis-ci.org/rduplain/Makefile.d)


### Overview

A sensational description would say, "Give a Makefile super powers!" but that
would be too much. There is already a project to provide a standard library for
GNU Make ([GMSL](https://gmsl.sourceforge.io/)), and _this_ Makefile.d project
does not provide a standard library. Besides, a simple Makefile is already
powerful; the work is to keep it simple.

The Makefile.d project provides a readily installable directory of .mk files
which together provide a programming environment for multiple runtimes.

Here, "multiple runtimes" indicates a project which has more than one
programming language, or which embeds/integrates one or more externally
developed services. Treating GNU Make as a _dependency-driven shell
environment_, it is possible to create single-command builds which download and
configure various tools and services in place, then fork multiple processes for
development to integrate these together.

Example use cases include:

* Manage vendor applications inside a monorepo, _without checking in code_
  from those projects.
* Load a Python environment with third-party packages _using only `python3` and
  a Makefile_. This is particularly useful for projects which are small, use
  Python to develop supporting tools in non-Python projects, or otherwise
  cannot reliably assume the developer has the latest Python tools installed.
* Integrating open-source services by _running a reliable development
  environment of those services entirely in one command_.

Each example use case is possible with a single `make` invocation on a newly
cloned project. The goal is to provide repeatable builds without assuming the
developer has every tool already installed. (At the very least, a failed build
can indicate which programs are missing.)


### Installation

Download `.Makefile.d-init.mk` to the project root:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://qwerty.sh | sh -s - \
    https://github.com/rduplain/Makefile.d.git .Makefile.d-init.mk
```

Include this .mk in the project Makefile, then include any .Makefile.d file:

```Makefile
include .Makefile.d-init.mk
include .Makefile.d/path.mk
```

That's it. Add `.Makefile.d` to .gitignore or equivalent. By default,
`.Makefile.d-init.mk` downloads a fixed revision of Makefile.d. Select a
different version by editing `MAKEFILE_D_REV` in the `.Makefile.d-init.mk`
file. The project Makefile will re-download the local `.Makefile.d`
installation automatically.

The Makefile.d project's 'master' branch is stable.


### Usage

Add include statements to the project's Makefile, e.g.:

```Makefile
include .Makefile.d/path.mk
```

Use variables and recipe patterns respective to included files. See
[test/python/Makefile](test/python/Makefile) and
[test/cljs/Makefile](test/cljs/Makefile) for example usage.


### Integration

Makefile.d .mk files that install project-local software use a convention of a
hidden dotfile directory at the project root, `.reqd`, under which a
Unix-familiar hierarchy applies:

* `.reqd/src` - Source code, typically to prepare installation to a `bin`.
* `.reqd/usr/bin` - Stand-alone executables.
* `.reqd/opt/<package>/bin` - Executables in package-specific directories.

By convention, project-local tools are available in Makefile variables. For
example, `python.mk` sets `$(PYTHON)` to the path of the `python` command
inside the newly configured virtualenv. Use of these variables ensures that
`make` invocation finds the correct installation of Makefile.d-installed
dependencies, without requiring any modifications to environment variable
paths.

Further convention has Makefile.d .mk files issue `export` statements for
environment variables, typically `PATH`, in order to have any command executed
by `make` be able to find the project-local paths.

To start an interactive shell in a configured environment, add a target to the
Makefile such as:

```Makefile
shell:
	@bash
```

Unfortunately, `make` overrides the conventional Unix environment variable
`SHELL`, so this `shell` target needs to read some other user configuration or
pick a shell (`bash`, `zsh`, ...) for the purpose of the project.

Another approach for an interactive shell is to start a new shell in the
project root directory, and have the profile/rc configuration add project-local
paths to relevant environment variables. For example, start `bash` in the
project root -- a common occurrence with terminal multiplexers such as `screen`
and `tmux` -- and have .bashrc include:

```bash
export PATH="$PWD"/.reqd/usr/bin:"$PATH"

for dir in "$PWD"/.reqd/opt/*/bin; do
    export PATH="$dir":"$PATH"
done
```

Additional variables may be needed, such as `GEM_HOME` in `ruby.mk`:

```bash
if [ -e "$PWD"/.reqd/opt/ruby ]; then
    export GEM_HOME="$PWD"/.reqd/opt/ruby
fi
```

In general, using this approach, look for `export` statements in .mk files and
port them to shell configuration.


### Platform Support

This project is cross-platform for Unix systems -- GNU/Linux, Mac OS X, ... --
as long as the Makefile is being run by GNU Make 3.81+, where 3.81 has a
release date in 2006. Specifically, these includes are not portable to non-GNU
implementations of Make (e.g. BSD Make) given dynamic features in use.


### Tests

Run tests:

```sh
./test/bin/test-suite
```


### Use of qwerty.sh

Makefile.d commonly downloads files to integrate dependencies, always using a
checksum or git to verify the download. Makefile.d uses [qwerty.sh][qwerty.sh
home] to reliably download, verify, and unpack dependencies, which is a
script-as-a-service available at https://qwerty.sh providing the latest version
of qwerty.sh by default.

To change this behavior, set the `QWERTY_SH_URL` environment variable to an
alternate download or `QWERTY_SH` to a local filepath, using one of the
following patterns:

```
QWERTY_SH_URL="https://qwerty.sh"
QWERTY_SH_URL="https://qwerty.sh/v0.6"
QWERTY_SH_URL="https://raw.githubusercontent.com/rduplain/qwerty.sh/master/qwerty.sh"
QWERTY_SH_URL="https://raw.githubusercontent.com/rduplain/qwerty.sh/v0.6/qwerty.sh"
QWERTY_SH="sh /path/to/qwerty.sh"
QWERTY_SH="/path/to/qwerty.sh"
```

When setting `QWERTY_SH` to a local filepath:

* Download qwerty.sh from <https://qwerty.sh>, which is always the latest
  release of qwerty.sh. Optionally include a version,
  e.g. <https://qwerty.sh/v0.6>.
* ... or from GitHub [through its "raw" file hosting][raw]; use a version tag
  by changing [`master`][raw] in the URL to a version tag, e.g. [`v0.6`][raw
  v].
  * Recommended: use a version tag, e.g. [`v0.6`][raw v]. Though
    [`master`][raw] is stable, it consistently refers to a pre-release; prefer
    a release version when downloading qwerty.sh.
* Ensure that the resulting file is executable: `chmod a+x /path/to/qwerty.sh`.
* Specify the absolute path to qwerty.sh.

[qwerty.sh home]: https://github.com/rduplain/qwerty.sh
[raw v]: https://raw.githubusercontent.com/rduplain/qwerty.sh/v0.6/qwerty.sh
[raw]: https://raw.githubusercontent.com/rduplain/qwerty.sh/master/qwerty.sh


---

[build]: https://travis-ci.org/rduplain/Makefile.d.svg?branch=master

Copyright (c) 2015-2021, R. DuPlain. BSD licensed.
