# Provide poorman to run a Procfile.

__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

POORMAN_URL ?= https://github.com/rduplain/poorman.git
POORMAN_REV ?= v0.6.2

ifeq ($(POORMAN_REV_DETACHED),true)
POORMAN_REV_SPEC ?= --ref $(POORMAN_REV)
else
POORMAN_REV_SPEC ?= --tag $(POORMAN_REV)
endif

include $(DIR)/path.mk
include $(DIR)/qwerty.mk

POORMAN := $(PROJECT_ROOT)/.reqd/usr/bin/poorman

export PATH := $(PROJECT_ROOT)/.reqd/usr/bin:$(PATH)

poorman-command: $(POORMAN)
	@true

$(POORMAN): $(__FILE__)
	@rm -f $@
	$(QWERTY_SH) $(POORMAN_REV_SPEC) --chmod=a+x $(POORMAN_URL) poorman:$@
