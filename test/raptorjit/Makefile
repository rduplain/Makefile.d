MAKEFILE := $(lastword $(MAKEFILE_LIST))

all: prove-lua prove-luarocks-install

include .Makefile.d/raptorjit.mk

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
	@lua -l say -v
	@echo "Finding 'luacheck' on PATH ..."
	@which luacheck

LUAROCKS_COMMANDS := \
	luarocks install luacheck 0.23.0 && \
	luarocks install say

$(LUAROCKS_INSTALL): $(MAKEFILE)
