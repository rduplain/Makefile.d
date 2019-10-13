# Provide bats testing framework.

__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

BATS_URL ?= https://github.com/sstephenson/bats.git
BATS_REV ?= v0.4.0

include $(DIR)/path.mk
include $(DIR)/qwerty.mk

BATS_SRC = $(PROJECT_ROOT)/.reqd/src/bats/$(BATS_REV)
BATS_PREFIX = $(PROJECT_ROOT)/.reqd/opt/bats
BATS = $(BATS_PREFIX)/bin/bats

export PATH := $(BATS_PREFIX)/bin:$(PATH)

bats-command: $(BATS)
	@true

$(BATS): $(__FILE__)
	$(QWERTY_SH) -f -o $(BATS_SRC) --tag $(BATS_REV) $(BATS_URL)
	cd $(BATS_SRC); ./install.sh $(BATS_PREFIX)
	touch $@
