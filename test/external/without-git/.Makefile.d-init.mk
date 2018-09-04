include .Makefile.d/path.mk

define qwerty-Makefile.d
curl -sSL qwerty.sh |\
	sh -s - \
	--sha256=6c75a7f055b49e2a53d8f44811a928351dbd1446ac4ae1d5bf828598a097dfd3 \
	https://github.com/rduplain/Makefile.d/tarball/e2949bc |\
			tar -xvzf - --strip-components=1
endef

.Makefile.d/%.mk:
	@mkdir -p .Makefile.d
	cd .Makefile.d; $(qwerty-Makefile.d)

prove-Makefile.d:
	@echo $(PROJECT_ROOT)
