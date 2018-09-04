include .Makefile.d/path.mk

define qwerty-Makefile.d
curl -sSL qwerty.sh |\
	sh -s - \
	--sha256=b3101c600ebaacd95bdee37eafe81394329b19b73d04d3a0d7a079e9f1074cca \
	https://github.com/rduplain/Makefile.d/tarball/a30fa71 |\
			tar -xvzf - --strip-components=1
endef

.Makefile.d/%.mk:
	@mkdir -p .Makefile.d
	cd .Makefile.d; $(qwerty-Makefile.d)

prove-Makefile.d:
	@echo $(PROJECT_ROOT)
