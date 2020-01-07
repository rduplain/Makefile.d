# Provide a project-local LuaJIT installation.
#
# To avoid collisions, do not use with lua.mk or other Lua implementations in
# Makefile.d.

LUAJIT_MK := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# LuaJIT 2.0.5 is an implementation of Lua 5.1.
LUAJIT_BASE_URL ?= http://luajit.org/download
LUAJIT_REV ?= 2.0.5
LUAJIT_URL ?= $(LUAJIT_BASE_URL)/LuaJIT-$(LUAJIT_REV).tar.gz
LUAJIT_SHA256 ?= \
	874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979

include $(DIR)/path.mk
include $(DIR)/qwerty.mk

LUAJIT_SRC = $(PROJECT_ROOT)/.reqd/src/luajit/$(LUAJIT_REV)
LUAJIT_PREFIX = $(PROJECT_ROOT)/.reqd/opt/luajit
LUAJIT = $(LUAJIT_PREFIX)/bin/luajit

# Support luarocks.mk with luajit.mk.
LUA_SRC = $(LUAJIT_SRC)
LUA_PREFIX = $(LUAJIT_PREFIX)
LUA = $(LUAJIT_PREFIX)/bin/lua

include $(DIR)/luarocks.mk

export PATH := $(LUAJIT_PREFIX)/bin:$(PATH)

luajit-command: $(LUAJIT)
	@true

lua-command: $(LUA)
	@true

$(LUAJIT): $(LUAJIT_SRC)/LuaJIT-$(LUAJIT_REV).tar.gz $(LUAJIT_MK)
	test -d $(LUAJIT_SRC) || mkdir -p $(LUAJIT_SRC)

	cd $(LUAJIT_SRC); tar -xf LuaJIT-$(LUAJIT_REV).tar.gz

	cd $(LUAJIT_SRC)/LuaJIT-$(LUAJIT_REV); \
		$(MAKE) PREFIX=$(LUAJIT_PREFIX) $(LUAJIT_BUILD_FLAGS) && \
		$(MAKE) PREFIX=$(LUAJIT_PREFIX) install

	@echo "LuaJIT executable in place: $(LUAJIT) ..."
	@touch $@

	@ln -sf $(LUAJIT) $(LUA)
	@echo "Lua symlink in place: $(LUA) ..."

$(LUAJIT_SRC)/LuaJIT-$(LUAJIT_REV).tar.gz:
	$(QWERTY_SH) --sha256=$(LUAJIT_SHA256) --output=$@ $(LUAJIT_URL)

$(LUA): $(LUAJIT)
