include .Makefile.d/path.mk

# See Makefile.d project README to compute SHA256.
MAKEFILE_D_VERSION := f8f0b3a
MAKEFILE_D_SHA256 := \
	4184efe87c5dd26761d532711ba6335cebcf221cf9f7a19202c0184d08b1266a
MAKEFILE_D_URL := \
	https://github.com/rduplain/Makefile.d/archive/$(MAKEFILE_D_VERSION).tar.gz

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
