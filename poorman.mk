__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/command.mk
include $(DIR)/path.mk

POORMAN_VERSION := v0.6.2
POORMAN_SHA256 := \
	111ef96d243b1bd49aae65b12e50142d71007bc7aaf9719c257671e8cf585a35

GITHUB_RAW := raw.githubusercontent.com
GITHUB_USER := rduplain

POORMAN := $(PROJECT_ROOT)/.reqd/usr/bin/poorman

$(POORMAN): $(__FILE__) | curl-command
	@rm -f $@
	@curl -sSL qwerty.sh |\
		sh -s - \
		--sha256=$(POORMAN_SHA256) \
		--output=$@ --chmod=a+x \
		https://$(GITHUB_RAW)/$(GITHUB_USER)/poorman/$(POORMAN_VERSION)/poorman

# Replace command.mk's `poorman-command` to download poorman.
poorman-command: $(POORMAN)
	@true
