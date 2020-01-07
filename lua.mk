# Provide a project-local Lua installation.
#
# Without an OS-specific patch, Lua does not support dynamic libraries (.so)
# when using `make posix`. This limits use of many luarocks-installable
# packages, including `luacheck`.

LUA_MK := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

LUA_BASE_URL ?= https://www.lua.org/ftp
LUA_REV ?= 5.3.5
LUA_URL ?= $(LUA_BASE_URL)/lua-$(LUA_REV).tar.gz
LUA_SHA256 ?= 0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac

include $(DIR)/path.mk
include $(DIR)/qwerty.mk

LUA_SRC = $(PROJECT_ROOT)/.reqd/src/lua/$(LUA_REV)
LUA_PREFIX = $(PROJECT_ROOT)/.reqd/opt/lua
LUA = $(LUA_PREFIX)/bin/lua

include $(DIR)/luarocks.mk

export PATH := $(LUA_PREFIX)/bin:$(PATH)

lua-command: $(LUA)
	@true

$(LUA): $(LUA_SRC)/lua-$(LUA_REV).tar.gz $(LUA_MK)
	test -d $(LUA_SRC) || mkdir -p $(LUA_SRC)

	cd $(LUA_SRC); tar -xf lua-$(LUA_REV).tar.gz

	cd $(LUA_SRC)/lua-$(LUA_REV); \
		sed -i'' -e "s|/usr/local|$(LUA_PREFIX)|g" Makefile src/luaconf.h && \
		$(MAKE) $(LUA_BUILD_FLAGS) posix && \
		$(MAKE) install

	@echo "Lua executable in place: $(LUA) ..."
	@touch $@

$(LUA_SRC)/lua-$(LUA_REV).tar.gz:
	$(QWERTY_SH) --sha256=$(LUA_SHA256) --output=$@ $(LUA_URL)
