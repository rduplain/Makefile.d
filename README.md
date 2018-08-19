## Makefile.d: Useful Makefile includes for runnable projects.

### Usage

Add include statements to the project's Makefile, e.g.:

```Makefile
include .Makefile.d/path.mk
```

Use variables and recipe patterns respective to included files. See
[test/Makefile](test/Makefile) for example usage.


### Installation

Add `.Makefile.d` to a project's .gitignore, or similar, and create a recipe in
the project's Makefile to download .Makefile.d (changing 'master' to a release
tag as desired):

```Makefile
.Makefile.d/%.mk:
	@git clone -b master https://github.com/rduplain/Makefile.d.git .Makefile.d
```

This will automatically download .Makefile.d to support include statements.

See:

* [test/external/with-git/Makefile](test/external/with-git/Makefile)

The Makefile.d's 'master' branch is stable.
