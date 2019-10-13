# Provide a full project-local Janet installation.

__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

JANET_URL ?= https://github.com/janet-lang/janet.git
JANET_REV ?= v1.3.1

include $(DIR)/path.mk
include $(DIR)/qwerty.mk

JANET_SRC = $(PROJECT_ROOT)/.reqd/src/janet/$(JANET_REV)
JANET_PREFIX = $(PROJECT_ROOT)/.reqd/opt/janet
JANET = $(JANET_PREFIX)/bin/janet
JPM = $(JANET_PREFIX)/bin/jpm

JPM_DEPS_INSTALLED = $(JANET_PREFIX)/lib/.jpm-deps-installed

export PATH := $(JANET_PREFIX)/bin:$(PATH)

janet-command: $(JANET)
	@true

jpm-command: $(JANET)
	@true

jpm-deps: jpm-command $(JPM_DEPS_INSTALLED)

$(JPM_DEPS_INSTALLED): project.janet
	@$(JPM) deps
	@touch $@

$(JANET): $(__FILE__)
	test -d $(JANET_SRC) || git clone $(JANET_URL) $(JANET_SRC)
	cd $(JANET_SRC); git checkout $(JANET_REV)
	cd $(JANET_SRC); make && make install
	@echo "Janet executable in place: $(JANET) ..."
	touch $@

$(JANET): export PREFIX = $(JANET_PREFIX)
$(JANET): export MANPATH = $(PREFIX)/share/man/man1/
$(JANET): export PKG_CONFIG_PATH = $(PREFIX)/lib/pkgconfig
