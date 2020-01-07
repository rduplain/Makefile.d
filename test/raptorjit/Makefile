all: prove-lua

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
