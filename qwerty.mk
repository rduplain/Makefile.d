# Provide qwerty.sh command via $(QWERTY_SH).

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(DIR)/command.mk

ifeq ($(QWERTY_SH),)
QWERTY_SH := curl -sSL qwerty.sh | sh -s -
endif
