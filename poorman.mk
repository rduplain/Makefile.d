# Provide poorman to run a Procfile.

__FILE__ := $(lastword $(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/command.mk
include $(DIR)/path.mk

POORMAN_URL := https://github.com/rduplain/poorman.git
POORMAN_REV := v0.6.2

# Though poorman.mk is functional without reqd.mk,
# it installs to reqd's conventional location.
POORMAN := $(PROJECT_ROOT)/.reqd/usr/bin/poorman

$(POORMAN): $(__FILE__) | curl-command
	@rm -f $@
	@curl -sSL qwerty.sh | sh -s - \
		--tag $(POORMAN_REV) --chmod=a+x $(POORMAN_URL) poorman:$@

# Replace command.mk's `poorman-command` to download poorman.
poorman-command: $(POORMAN)
	@true
