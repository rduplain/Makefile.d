__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/command.mk
include $(DIR)/path.mk

REQD_VERSION := v2.0
REQD_SHA256 := dca4495f40c1b5c23b1f6edf7405ee56d4c6ff224c972de002ec852b48dd2797

GITHUB_RAW := raw.githubusercontent.com
GITHUB_USER := rduplain

export REQD_DIR    := $(PROJECT_ROOT)/.reqd
export REQD_PREFIX := $(REQD_DIR)/usr
export REQD_BIN    := $(REQD_DIR)/bin
export REQD_SBIN   := $(REQD_DIR)/sbin
export REQD_LIB    := $(REQD_DIR)/lib
export REQD_ETC    := $(REQD_DIR)/etc
export REQD_SRC    := $(REQD_DIR)/src
export REQD_OPT    := $(REQD_DIR)/opt
export REQD_VAR    := $(REQD_DIR)/var

REQD := $(REQD_BIN)/reqd

$(REQD): $(__FILE__) | curl-command
	@rm -f $@
	@curl -sSL qwerty.sh |\
		sh -s - \
		--sha256=$(REQD_SHA256) \
		--output=$@ --chmod=a+x \
		https://$(GITHUB_RAW)/$(GITHUB_USER)/reqd/$(REQD_VERSION)/bin/reqd

reqd-%: $(REQD)
	@$(REQD) install $*
