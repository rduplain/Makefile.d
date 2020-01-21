MAKEFILE := $(lastword $(MAKEFILE_LIST))

all: prove-lua prove-luarocks-install

include .Makefile.d/luajit.mk

prove-lua: lua-command luarocks-command
	@echo "Verifying Lua install ..."
	@echo "Show LuaRocks help:"
	@"$(LUAROCKS)" --help
	@echo
	@echo "That is LuaRocks's help above. Thank you, LuaRocks."
	@echo
	@echo "Show Lua version:"
	@"$(LUA)" -e "print(_VERSION)"

prove-luarocks-install: luarocks-install
	@echo "Verifying LuaRocks install of 'say' module ..."
	@$(LUA) -l say -v
	@echo "Finding 'luacheck' ..."
	$(LUA_PREFIX)/bin/luacheck --version

LUAROCKS_COMMANDS := \
	$(LUAROCKS) install luacheck 0.23.0 && \
	$(LUAROCKS) install say

$(LUAROCKS_INSTALL): $(MAKEFILE)
