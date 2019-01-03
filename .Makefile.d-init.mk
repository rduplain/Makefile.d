__FILE__ := $(abspath $(lastword $(MAKEFILE_LIST)))

MAKEFILE_D_URL := https://github.com/rduplain/Makefile.d.git
MAKEFILE_D_REV := v1.0

ifeq ($(QWERTY_SH),)
QWERTY_SH := curl -sSL qwerty.sh | sh -s -
endif

.Makefile.d/%.mk: .Makefile.d/path.mk
	@touch $@

.Makefile.d/path.mk: $(__FILE__)
	$(QWERTY_SH) -f -o .Makefile.d --ref $(MAKEFILE_D_REV) $(MAKEFILE_D_URL)
	@touch $@
