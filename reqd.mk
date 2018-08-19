__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/command.mk
include $(DIR)/path.mk

REQD_VERSION := v2.0
REQD_SHA256 := dca4495f40c1b5c23b1f6edf7405ee56d4c6ff224c972de002ec852b48dd2797

GITHUB_RAW := raw.githubusercontent.com
GITHUB_USERNAME := rduplain

export REQD_DIR := $(PROJECT_ROOT)/.reqd

reqd := $(REQD_DIR)/bin/reqd

$(reqd): $(__FILE__) | curl-command
	@rm -f $@
	@curl -sSL qwerty.sh |\
		sh -s - \
		--sha256=$(REQD_SHA256) \
		--output=$@ --chmod=a+x \
		https://$(GITHUB_RAW)/$(GITHUB_USERNAME)/reqd/$(REQD_VERSION)/bin/reqd

reqd-%: $(reqd)
	@$(reqd) install $*
