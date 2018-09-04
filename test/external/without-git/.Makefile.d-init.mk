include .Makefile.d/path.mk

# See Makefile.d project README to compute SHA256.
MAKEFILE_D_VERSION := e2949bc
MAKEFILE_D_SHA256 := \
	6c75a7f055b49e2a53d8f44811a928351dbd1446ac4ae1d5bf828598a097dfd3
MAKEFILE_D_URL := \
	https://github.com/rduplain/Makefile.d/tarball/$(MAKEFILE_D_VERSION)

.Makefile.d/%.mk:
	@mkdir -p .Makefile.d
	cd .Makefile.d; curl -sSL qwerty.sh |\
		sh -s - \
		--sha256=$(MAKEFILE_D_SHA256) \
		$(MAKEFILE_D_URL) |\
			tar -xvzf - --strip-components=1

prove-Makefile.d:
	@echo $(PROJECT_ROOT)
