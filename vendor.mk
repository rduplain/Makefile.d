__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/path.mk

NIXD_VERSION := 99053ca3d12b82975720ae56245e25983cac3e91
NIXD_SHA256 := 1bc4594ab25f71673fc958997852243e5e137863f90de16d8a21a42a999e7b6a

VENDOR := $(PROJECT_ROOT)/.nixd
nixd := $(VENDOR)/bin/nixd

export VENDOR

$(nixd): $(__FILE__)
	@rm -f $@
	@$(VENDOR)/bin/nixd-bootstrap $(nixd) $(NIXD_VERSION) sha256 $(NIXD_SHA256)

vendor-%: $(nixd)
	@$(nixd) install $*
