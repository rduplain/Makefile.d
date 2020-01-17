# Provide a relative installation path for Ruby gems.
#
# Supports Ruby 2.4+.

RUBY_MIN_VERSION ?= 2.4

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(DIR)/command.mk
include $(DIR)/path.mk

RUBY := ruby
GEM_HOME := $(PROJECT_ROOT)/.reqd/opt/ruby
GEM_PATH := $(GEM_HOME)
BUNDLE := $(GEM_HOME)/bin/bundle

RUBY_BUNDLER_VERSION ?= 2.1.4

export PATH := $(GEM_HOME)/bin:$(PATH)
export GEM_HOME

bundle-command: $(BUNDLE)

bundle-%: bundle-command
	@$(BUNDLE) $*

$(BUNDLE): | gem-command
	@$(DIR)/bin/check-ruby-version $(RUBY) $(RUBY_MIN_VERSION)
	@gem install \
		--install-dir $(GEM_HOME) \
		--no-document \
		-v $(RUBY_BUNDLER_VERSION) bundler

export GEM_HOME
export GEM_PATH
