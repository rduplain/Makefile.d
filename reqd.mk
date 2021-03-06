# Provide reqd to download & install required tools.

REQD_MK := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(DIR)/command.mk
include $(DIR)/path.mk
include $(DIR)/qwerty.mk

REQD_URL ?= https://github.com/rduplain/reqd.git
REQD_REV ?= v2.2

ifeq ($(REQD_REV_DETACHED),true)
REQD_REV_SPEC ?= --ref $(REQD_REV)
else
REQD_REV_SPEC ?= --tag $(REQD_REV)
endif

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

export PATH := $(REQD_PREFIX)/bin:$(REQD_BIN):$(PATH)

# Accept space-delimited ordered recipe list to install when installing 'all'.
ifeq ($(REQD_FIRST),)
REQD_FIRST := all
endif

reqd-command: $(REQD)

$(REQD): $(REQD_MK)
	$(QWERTY_SH) -f --chmod=a+x -o $(REQD_DIR) $(REQD_REV_SPEC) $(REQD_URL) \
		bin/reqd

reqd-%: $(REQD)
	@$(REQD) install $*

reqd-all: $(REQD)
	@$(REQD) install $(REQD_FIRST)
	@$(REQD) install all
