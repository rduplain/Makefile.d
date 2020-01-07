# Provide LuaRocks within project-local Lua installation.
#
# This .mk is not intended for direct inclusion in user projects. It depends on
# variables set by lua.mk and is included automatically by lua.mk and
# luajit.mk.
#
# Makefile.d builds project-local binaries for `lua` and `luarocks` at a
# relative directory. Accordingly, `luarocks` will install its system/global
# tree to a project-local directory. By convention, given this behavior,
# projects using this .mk include can use unqualified `luarocks` installation
# commands (and not --local features of `luarocks`) so that resulting packages
# install to a project-local directory.

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

LUAROCKS_BASE_URL ?= https://luarocks.org/releases
LUAROCKS_REV ?= 3.2.1
LUAROCKS_URL ?= $(LUAROCKS_BASE_URL)/luarocks-$(LUAROCKS_REV).tar.gz
LUAROCKS_SHA256 ?= \
	f27e20c9cdb3ffb991ccdb85796c36a0690566676f8e1a59b0d0ee6598907d04

include $(DIR)/qwerty.mk

LUAROCKS = $(LUA_PREFIX)/bin/luarocks

luarocks-command: $(LUAROCKS)
	@true

$(LUAROCKS): $(LUA_SRC)/luarocks-$(LUAROCKS_REV).tar.gz $(LUA)
	cd $(LUA_SRC); tar -xf luarocks-$(LUAROCKS_REV).tar.gz

	cd $(LUA_SRC)/luarocks-$(LUAROCKS_REV); \
		./configure --prefix=$(LUA_PREFIX) --with-lua=$(LUA_PREFIX) \
			--with-lua-include=$(shell cd $(LUA_INCLUDE) && pwd) \
			--with-lua-lib=$(shell cd $(LUA_LIB) && pwd) && \
		$(MAKE) $(LUAROCKS_BUILD_FLAGS) && \
		$(MAKE) install

	@echo "LuaRocks executable in place: $(LUAROCKS) ..."
	@touch $@

$(LUA_SRC)/luarocks-$(LUAROCKS_REV).tar.gz:
	$(QWERTY_SH) --sha256=$(LUAROCKS_SHA256) --output=$@ $(LUAROCKS_URL)
