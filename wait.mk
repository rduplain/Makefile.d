# Wait for a TCP port to open as a dependency target.

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

WAIT_POLL_INTERVAL ?= 0.25

include $(DIR)/command.mk

wait-tcp-%: nc-command
	@bash -c "while ! nc -z $(HOST) $*; do sleep $(WAIT_POLL_INTERVAL); done"

wait-tcp-%: HOST := localhost
