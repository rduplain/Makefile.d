# Provide qwerty.sh command via $(QWERTY_SH).

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(DIR)/command.mk

ifeq ($(QWERTY_SH_URL),)
QWERTY_SH_URL := qwerty.sh
endif

ifeq ($(QWERTY_SH),)
QWERTY_SH := curl -sSL $(QWERTY_SH_URL) | sh -s -
endif
