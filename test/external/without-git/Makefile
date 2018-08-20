include .Makefile.d/path.mk

# See Makefile.d project README to compute SHA256.
MAKEFILE_D_VERSION := cbf325a
MAKEFILE_D_SHA256 := \
	856e083e3e677a7e88501f21ecc3b2902fcdc4736b2bea4deea3193b1d12da0e
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
