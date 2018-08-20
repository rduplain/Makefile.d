## Makefile.d: Useful Makefile includes for runnable projects.

[![Build Status][build]](https://travis-ci.org/rduplain/Makefile.d)


### Usage

Add include statements to the project's Makefile, e.g.:

```Makefile
include .Makefile.d/path.mk
```

Use variables and recipe patterns respective to included files. See
[test/Makefile](test/Makefile) for example usage.


### Platform Support

This project is cross-platform for Unix systems -- GNU/Linux, Mac OS X, ... --
as long as the Makefile is being run by GNU Make 3.81+, where 3.81 has a
release date in 2006. Specifically, these includes are not portable to non-GNU
implementations of Make (e.g. BSD Make) given dynamic features in use.


### Installation

Add `.Makefile.d` to a project's .gitignore, or similar, and create a recipe in
the project's Makefile to download .Makefile.d (changing 'master' to a release
tag as desired):

```Makefile
.Makefile.d/%.mk:
	@git clone -b master https://github.com/rduplain/Makefile.d.git .Makefile.d
```

This will automatically download .Makefile.d to support include statements.

Example, with git:

* [test/external/with-git/Makefile](test/external/with-git/Makefile)

The Makefile.d's 'master' branch is stable.


### Installation Without `git`

Example, without git:

* [test/external/without-git/Makefile](test/external/without-git/Makefile)

The 'without-git' Makefile linked above shows how to install without using git,
while still verifying integrity of the download. To compute the SHA256
checksum, use git in a development environment. First `git checkout` the ref of
interest. Then, run the following command line to get a SHA256 checksum.

Note that this assumes GitHub provides tarballs with gzip compression level 6,
which is true as of the time of this writing, but is an undocumented
implementation detail. Further, this assumes a tarball prefix directory using
the GitHub username and project name, followed by `git rev-parse` with the
short format, which is also an implementation detail.

```sh
./test/bin/generate-sha256
```

Optionally provide a ref:

```sh
./test/bin/generate-sha256 f8f0b3a
```


### Tests

Run tests:

```sh
./test/bin/test-suite
```


[build]: https://travis-ci.org/rduplain/Makefile.d.svg?branch=master


---

Copyright (c) 2015-2018, Ron DuPlain. BSD licensed.
