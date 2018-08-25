# Print qwerty.sh command invocations to download the project.

DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifeq ($(GIT_REF),)
GIT_REF := HEAD
endif

archive-sha256:
	@$(DIR)/bin/generate-sha256 --checksum $(GIT_REF)

qwerty-command:
	@$(DIR)/bin/generate-sha256 --qwerty $(GIT_REF)

qwerty-command-release:
	@$(DIR)/bin/generate-sha256 --qwerty --release
