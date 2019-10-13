# Provide poorman to run a Procfile.

__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

POORMAN_URL ?= https://github.com/rduplain/poorman.git
POORMAN_REV ?= v0.6.2

include $(DIR)/path.mk
include $(DIR)/qwerty.mk

# reqd is not required, but use its conventional location.
POORMAN := $(PROJECT_ROOT)/.reqd/usr/bin/poorman

export PATH := $(PROJECT_ROOT)/.reqd/usr/bin:$(PATH)

poorman-command: $(POORMAN)
	@true

$(POORMAN): $(__FILE__)
	@rm -f $@
	$(QWERTY_SH) --tag $(POORMAN_REV) --chmod=a+x $(POORMAN_URL) poorman:$@
