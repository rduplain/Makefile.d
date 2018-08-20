include .Makefile.d/path.mk

# See Makefile.d project README to compute SHA256.
MAKEFILE_D_VERSION := 4e27204
MAKEFILE_D_SHA256 := \
	3a681ef421c08791ff59546b5847c920c02be3081c6621428ec720af67a72929
MAKEFILE_D_URL := \
	https://github.com/rduplain/Makefile.d/tarball/$(MAKEFILE_D_VERSION)

# Change 'master' to a release tag as desired.
.Makefile.d/%.mk:
	@mkdir -p .Makefile.d
	cd .Makefile.d; curl -sSL qwerty.sh |\
		sh -s - \
		--sha256=$(MAKEFILE_D_SHA256) \
		$(MAKEFILE_D_URL) |\
			tar -xvzf - --strip-components=1

prove-Makefile.d:
	@echo $(PROJECT_ROOT)
