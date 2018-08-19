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

Example, with git:

* [test/external/with-git/Makefile](test/external/with-git/Makefile)

The Makefile.d's 'master' branch is stable.


## Installation Without `git`

Example, without git:

* [test/external/without-git/Makefile](test/external/without-git/Makefile)

The 'without-git' Makefile linked above shows how to install without using git
while still verifying integrity of the download. To compute the SHA256
checksum, use git in a development environment . First `git checkout` the
reference of interest. Then, run the following command line to get a SHA256
checksum matching a git short ref (e.g. 'c0ffee', not v0.x) download from
GitHub. Note that this assumes GitHub provides tarballs with gzip compression
level 6 (as in `-6` in the command below), which is true as of the time of this
writing, but is an undocumented implementation detail. Further, this assumes a
prefix directory using `git rev-parse` (as below), which is also an
implementation detail.

```sh
git archive \
    --prefix=Makefile.d-$(git rev-parse --short HEAD)/ \
    --format=tar.gz -6 HEAD |\
        openssl dgst -sha256 |\
            awk '{ print $2 }'
```


---

Copyright (c) 2015-2018, Ron DuPlain. BSD licensed.
