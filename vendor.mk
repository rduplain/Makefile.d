DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/path.mk

NIXD_VERSION := 7bafe5c3a49c784a5b2e6a999d1f28d719843b94
NIXD_SHA1SUM := 22981df71e81f2780ded6874a0dbec78ad18710d

VENDOR := $(PROJECT_ROOT)/.nixd
nixd := $(VENDOR)/bin/nixd

export VENDOR

$(nixd):
	@$(VENDOR)/bin/nixd-bootstrap $(nixd) $(NIXD_VERSION) sha1 $(NIXD_SHA1SUM)

vendor-%: $(nixd)
	@$(nixd) install $*
