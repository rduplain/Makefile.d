all: prove-bats prove-janet

include .Makefile.d/bats.mk

prove-bats: bats-command
	@echo "Verifying bats install ..."
	@$(BATS) -h

include .Makefile.d/janet.mk

prove-janet: janet-command jpm-command
	@echo "Verifying Janet install ..."
	@$(JPM) --help
	@$(JANET) -e "(print (string \"Janet \" janet/version))"
