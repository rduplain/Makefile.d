# Print qwerty.sh command invocations to download the project.

DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# Control output with GIT_REF and QWERTY_FLAGS environment:
#
#     GIT_REF=4e27204 QWERTY_FLAGS="--output=/tmp/foo.tar.gz --chmod=400" \
#         make qwerty-command

ifeq ($(GIT_REF),)
GIT_REF := HEAD
endif

archive-sha256:
	@$(DIR)/bin/generate-sha256 --checksum $(GIT_REF)

qwerty-command:
	@$(DIR)/bin/generate-sha256 --qwerty $(GIT_REF)

qwerty-command-release:
	@$(DIR)/bin/generate-sha256 --qwerty --release
