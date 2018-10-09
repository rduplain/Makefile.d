# Provide bats testing framework.

__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/command.mk
include $(DIR)/path.mk

BATS_VERSION := 0.4.0
BATS_FORK := sstephenson/bats
BATS_SHA256 := \
	480d8d64f1681eee78d1002527f3f06e1ac01e173b761bc73d0cf33f4dc1d8d7

# Tag is prefixed with 'v'; unpacked directory is not.
BATS_TAG = v$(BATS_VERSION)
BATS_ARCHIVE = bats-$(BATS_VERSION).tar.gz

# Though bats.mk is functional without reqd.mk,
# it installs to reqd's conventional location.
BATS_SRC = $(PROJECT_ROOT)/.reqd/src/bats
BATS_UNPACKED_PATH = $(BATS_SRC)/bats-$(BATS_VERSION)
BATS_PREFIX = $(PROJECT_ROOT)/.reqd/opt/bats
BATS = $(BATS_PREFIX)/bin/bats

export BATS

bats-command: $(BATS)

$(BATS): $(BATS_SRC)
	@cd $(BATS_SRC)/bats-$(BATS_VERSION); ./install.sh $(BATS_PREFIX)

$(BATS_SRC): $(BATS_UNPACKED_PATH)/README.md

$(BATS_UNPACKED_PATH)/README.md: $(BATS_SRC)/$(BATS_ARCHIVE)
	@cd $(BATS_SRC); tar -xvzf $(BATS_ARCHIVE)
	@touch $@

$(BATS_SRC)/$(BATS_ARCHIVE): $(__FILE__) | curl-command
	@curl -sSL qwerty.sh |\
		sh -s - \
		--sha256=$(BATS_SHA256) \
		--output=$@ \
		https://github.com/$(BATS_FORK)/archive/$(BATS_TAG).tar.gz
	@touch $@

clean-bats:
	rm -fr $(BATS_PREFIX) $(BATS_SRC)

.PHONY: bats-command
