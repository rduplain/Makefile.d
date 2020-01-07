all: prove-bats prove-janet prove-lua

include .Makefile.d/bats.mk

prove-bats: bats-command
	@echo "Verifying bats install ..."
	@$(BATS) -h

include .Makefile.d/janet.mk

prove-janet: janet-command jpm-command
	@echo "Verifying Janet install ..."
	@echo "Show jpm help:"
	@$(JPM) --help
	@echo
	@echo "That is jpm's help above. Thank you, jpm."
	@echo
	@echo "Show Janet version:"
	@$(JANET) -e "(print (string \"Janet \" janet/version))"

include .Makefile.d/lua.mk

prove-lua: lua-command luarocks-command
	@echo "Verifying Lua install ..."
	@echo "Show LuaRocks help:"
	@"$(LUAROCKS)" --help
	@echo
	@echo "That is LuaRocks's help above. Thank you, LuaRocks."
	@echo
	@echo "Show Lua version:"
	@"$(LUA)" -e "print(_VERSION)"
