all: prove-bats

include .Makefile.d/bats.mk

prove-bats: bats-command
	@echo "Verifying bats install ..."
	@$(BATS) -h
