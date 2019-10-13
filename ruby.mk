# Provide a relative installation path for Ruby gems.

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(DIR)/command.mk
include $(DIR)/path.mk

RUBY := ruby
GEM_HOME := $(PROJECT_ROOT)/.reqd/opt/ruby
GEM_PATH := $(GEM_HOME)
BUNDLE := $(GEM_HOME)/bin/bundle

ifeq ($(RUBY_BUNDLER_VERSION),)
RUBY_BUNDLER_VERSION := 2.0.2
endif

export PATH := $(GEM_HOME)/bin:$(PATH)

bundle-command: $(BUNDLE)

bundle-%: bundle-command
	@$(BUNDLE) $*

$(BUNDLE): | gem-command
	@gem install \
		--install-dir $(GEM_HOME) \
		--no-document \
		-v $(RUBY_BUNDLER_VERSION) bundler

export GEM_HOME
export GEM_PATH
