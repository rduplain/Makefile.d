# Provide a project-local Lua installation.
#
# Lua: Without an OS-specific patch, Lua does not support dynamic libraries
# (.so) when using `make posix`. This limits use of many luarocks-installable
# packages, including `luacheck`.
#
# LuaRocks: This .mk builds project-local binaries for `lua` and `luarocks` at
# a relative directory. Accordingly, `luarocks` will install its system/global
# tree to a project-local directory. By convention, given this behavior,
# projects using this .mk include can use unqualified `luarocks` installation
# commands (and not --local features of `luarocks`) so that resulting packages
# install to a project-local directory.

LUA_MK := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

LUA_BASE_URL ?= https://www.lua.org/ftp
LUA_REV ?= 5.3.5
LUA_URL ?= $(LUA_BASE_URL)/lua-$(LUA_REV).tar.gz
LUA_SHA256 ?= 0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac

LUAROCKS_BASE_URL ?= https://luarocks.org/releases
LUAROCKS_REV ?= 3.2.1
LUAROCKS_URL ?= $(LUAROCKS_BASE_URL)/luarocks-$(LUAROCKS_REV).tar.gz
LUAROCKS_SHA256 ?= \
	f27e20c9cdb3ffb991ccdb85796c36a0690566676f8e1a59b0d0ee6598907d04

include $(DIR)/path.mk
include $(DIR)/qwerty.mk

LUA_SRC = $(PROJECT_ROOT)/.reqd/src/lua/$(LUA_REV)
LUA_PREFIX = $(PROJECT_ROOT)/.reqd/opt/lua
LUA = $(LUA_PREFIX)/bin/lua
LUAROCKS = $(LUA_PREFIX)/bin/luarocks

export PATH := $(LUA_PREFIX)/bin:$(PATH)

lua-command: $(LUA)
	@true

luarocks-command: $(LUAROCKS)
	@true

$(LUA): $(LUA_MK)
	test -d $(LUA_SRC) || mkdir -p $(LUA_SRC)

	$(QWERTY_SH) --sha256=$(LUA_SHA256) \
		--output=$(LUA_SRC)/lua-$(LUA_REV).tar.gz \
		$(LUA_URL)

	cd $(LUA_SRC); tar -xf lua-$(LUA_REV).tar.gz

	cd $(LUA_SRC)/lua-$(LUA_REV); \
		sed -i'' -e "s|/usr/local|$(LUA_PREFIX)|g" Makefile src/luaconf.h && \
		$(MAKE) $(LUA_BUILD_FLAGS) posix && \
		$(MAKE) install

	@echo "Lua executable in place: $(LUA) ..."
	@touch $@

$(LUAROCKS): $(LUA)
	$(QWERTY_SH) --sha256=$(LUAROCKS_SHA256) \
		--output=$(LUA_SRC)/luarocks-$(LUAROCKS_REV).tar.gz \
		$(LUAROCKS_URL)

	cd $(LUA_SRC); tar -xf luarocks-$(LUAROCKS_REV).tar.gz

	cd $(LUA_SRC)/luarocks-$(LUAROCKS_REV); \
		./configure --prefix=$(LUA_PREFIX) --with-lua=$(LUA_PREFIX) && \
		$(MAKE) $(LUAROCKS_BUILD_FLAGS) && \
		$(MAKE) install

	@echo "LuaRocks executable in place: $(LUAROCKS) ..."
	@touch $@
