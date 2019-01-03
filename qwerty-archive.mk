# Print qwerty.sh command invocations to download the project.

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# Control output with GIT_REF and QWERTY_FLAGS environment:
#
#     GIT_REF=4e27204 QWERTY_FLAGS="--output=/tmp/foo.tar.gz --chmod=400" \
#         make qwerty-archive

ifeq ($(GIT_REV),)
GIT_REV := HEAD
endif

archive-sha256:
	@$(DIR)/bin/generate-sha256 --checksum $(GIT_REV)

qwerty-archive:
	@$(DIR)/bin/generate-sha256 --qwerty $(GIT_REV)

qwerty-archive-release:
	@$(DIR)/bin/generate-sha256 --qwerty --release
