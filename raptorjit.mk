# Provide a project-local RaptorJIT (LuaJIT fork) installation.
#
# To avoid collisions, do not use with lua.mk or other Lua implementations in
# Makefile.d.
#
# Note that as of v1.0, RaptorJIT only supports Linux x86_64.

RAPTORJIT_MK := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# Raptorjit 1.0.3 is an implementation of Lua 5.1.
RAPTORJIT_URL ?= https://github.com/raptorjit/raptorjit.git
RAPTORJIT_REV ?= v1.0.3

include $(DIR)/path.mk
include $(DIR)/qwerty.mk

RAPTORJIT_SRC = $(PROJECT_ROOT)/.reqd/src/raptorjit/$(RAPTORJIT_REV)
RAPTORJIT_PREFIX = $(PROJECT_ROOT)/.reqd/opt/raptorjit
RAPTORJIT_INSTALL = $(RAPTORJIT_PREFIX)/bin/.raptorjit-install
RAPTORJIT = $(RAPTORJIT_PREFIX)/bin/raptorjit

LUAJIT = $(RAPTORJIT_PREFIX)/bin/luajit

# Support luarocks.mk.
LUA_INCLUDE = $(RAPTORJIT_PREFIX)/include/raptorjit-*
LUA_LIB = $(RAPTORJIT_PREFIX)/lib
LUA_SRC = $(PROJECT_ROOT)/.reqd/src/luarocks
LUA_PREFIX = $(RAPTORJIT_PREFIX)
LUA = $(RAPTORJIT_PREFIX)/bin/lua

include $(DIR)/luarocks.mk

export PATH := $(RAPTORJIT_PREFIX)/bin:$(PATH)

raptorjit-command: $(RAPTORJIT)
	@true

luajit-command: $(LUAJIT)
	@true

lua-command: $(LUA)
	@true

$(RAPTORJIT_INSTALL): $(RAPTORJIT_MK)
	test -d $(RAPTORJIT_SRC) || $(QWERTY_SH) \
		--output=$(RAPTORJIT_SRC) --tag $(RAPTORJIT_REV) $(RAPTORJIT_URL)

	cd $(RAPTORJIT_SRC); \
		$(MAKE) reusevm && \
		$(MAKE) PREFIX=$(RAPTORJIT_PREFIX) $(RAPTORJIT_BUILD_FLAGS) && \
		$(MAKE) PREFIX=$(RAPTORJIT_PREFIX) install

	@test -x $(RAPTORJIT)
	@echo "Raptorjit executable in place: $(RAPTORJIT) ..."
	@touch $@

	@ln -sf $(RAPTORJIT) $(LUAJIT)
	@echo "LuaJIT symlink in place: $(LUAJIT) ..."

	@ln -sf $(RAPTORJIT) $(LUA)
	@echo "Lua symlink in place: $(LUA) ..."

$(RAPTORJIT): $(RAPTORJIT_INSTALL)
$(LUAJIT): $(RAPTORJIT)
$(LUA): $(RAPTORJIT)

$(LUAROCKS): $(RAPTORJIT_INSTALL)
