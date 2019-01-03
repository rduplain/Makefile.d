# Generate a Procfile dynamically, with process entry points in make.

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(DIR)/path.mk

Procfile := $(PROJECT_ROOT)/Procfile

# The `proc` target resets the procfile.
proc:
	@rm -f $(Procfile)
	@touch $(Procfile)

proc-%:
	@echo "$*: make --no-print-directory run-$*" >> $(Procfile)
