__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/path.mk

NIXD_VERSION := v1.0
NIXD_SHA256 := 2cfe294fa454d67f31cf71b150aa969b81938e3eb854d45fd2251761a2401be3

VENDOR := $(PROJECT_ROOT)/.nixd
nixd := $(VENDOR)/bin/nixd

export VENDOR

$(nixd): $(__FILE__)
	@rm -f $@
	@$(VENDOR)/bin/nixd-bootstrap $(nixd) $(NIXD_VERSION) sha256 $(NIXD_SHA256)

vendor-%: $(nixd)
	@$(nixd) install $*
