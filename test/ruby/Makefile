## Developer Tasks

test: rspec-command
	@$(RSPEC)


## Run Recipes w/Automated Requirements

include .Makefile.d/ruby.mk

RSPEC := $(GEM_HOME)/bin/rspec

$(RSPEC): Gemfile | bundle-command
	@$(BUNDLE) install
	@touch $@

rspec-command: $(RSPEC)
	@true
