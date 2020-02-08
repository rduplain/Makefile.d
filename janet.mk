# Provide a project-local Janet installation.

JANET_MK := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

JANET_URL ?= https://github.com/janet-lang/janet.git
JANET_REV ?= v1.7.0

include $(DIR)/path.mk

JANET_SRC = $(PROJECT_ROOT)/.reqd/src/janet/$(JANET_REV)
JANET_PREFIX = $(PROJECT_ROOT)/.reqd/opt/janet
JANET = $(JANET_PREFIX)/bin/janet
JPM = $(JANET_PREFIX)/bin/jpm

JPM_DEPS_INSTALL = $(JANET_PREFIX)/lib/.jpm-deps-install

export PATH := $(JANET_PREFIX)/bin:$(PATH)

janet-command: $(JANET)
	@true

jpm-command: $(JANET)
	@true

jpm-deps: jpm-command $(JPM_DEPS_INSTALL)

$(JPM_DEPS_INSTALL): project.janet
	@$(JPM) deps
	@touch $@

# Note that Janet inspects git during its build; retain Janet .git directory.
$(JANET): $(JANET_MK)
	test -d $(JANET_SRC) || git clone $(JANET_URL) $(JANET_SRC)
	cd $(JANET_SRC); git checkout $(JANET_REV)
	cd $(JANET_SRC); $(MAKE) $(JANET_BUILD_FLAGS) && $(MAKE) install
	@echo "Janet executable in place: $(JANET) ..."
	@touch $@

$(JANET): export PREFIX = $(JANET_PREFIX)
$(JANET): export MANPATH = $(PREFIX)/share/man/man1/
$(JANET): export PKG_CONFIG_PATH = $(PREFIX)/lib/pkgconfig
