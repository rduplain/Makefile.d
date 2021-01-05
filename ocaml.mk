# Switch opam to project-local path, install deps with opam, build with dune.

OCAML_MK := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

OCAML_REV ?= 4.11.1
DUNE_REV ?= 2.7.1
UTOP_REV ?= 2.6.0

include $(DIR)/command.mk
include $(DIR)/path.mk

_OPAM ?= $(PROJECT_ROOT)/_opam
OCAML ?= $(_OPAM)/bin/ocaml
DUNE ?= $(_OPAM)/bin/dune
UTOP ?= $(_OPAM)/bin/utop

OPAM_INSTALL := $(_OPAM)/lib/.opam-install
OPAM_UPDATE := $(_OPAM)/lib/.opam-update

# Re-create `eval $(opam env)`.
export OPAM_SWITCH_PREFIX := $(_OPAM)
export OCAML_TOPLEVEL_PATH := $(_OPAM)/lib/toplevel
export MANPATH := $(_OPAM)/man:$(MANPATH)
export PATH := $(_OPAM)/bin:$(PATH)

CAML_LD_LIBRARY_PATH := $(_OPAM)/lib/stublibs:$(_OPAM)/lib/ocaml/stublibs
CAML_LD_LIBRARY_PATH := $(CAML_LD_LIBRARY_PATH):$(_OPAM)/lib/ocaml
export CAML_LD_LIBRARY_PATH

# Hook development dependencies listed in OPAM_DEV variable.
ifeq ($(OPAM_DEV),)
OPAM_INSTALL_DEV :=
else
OPAM_INSTALL_DEV := opam install --yes $(OPAM_DEV)
endif

ocaml-command: $(OCAML)
	@true

dune-command: $(DUNE)
	@true

utop-command: $(UTOP)
	@true

$(OCAML):
	@if ! $(DIR)/bin/opam-check-switch $(_OPAM) $(OCAML_REV); \
		then \
			rm -fr $(_OPAM); \
			opam switch create --yes --deps-only \
				$(PROJECT_ROOT) \
				ocaml-base-compiler.$(OCAML_REV); \
		fi

.PHONY: $(OCAML)

$(DUNE): $(OCAML_MK) | $(OCAML) opam-update
	@opam install --yes dune.$(DUNE_REV)
	@touch $@

$(UTOP): $(OCAML_MK) | $(OCAML)
	@opam install --yes utop.$(UTOP_REV)
	@touch $@

opam-install: $(OPAM_INSTALL) | $(OCAML)
	@true

$(OPAM_INSTALL): $(OCAML_MK) dune-project | dune-command opam-update
	@$(DUNE) build @install
	@echo
	@opam install --yes --deps-only $(PROJECT_ROOT)
	@$(OPAM_INSTALL_DEV)
	@touch $@

opam-update: $(OPAM_UPDATE) | $(OCAML)
	@true

$(OPAM_UPDATE): $(OCAML_MK)
	@opam update
	@touch $@

ocaml-clean:
	@rm -f $(OPAM_INSTALL) $(OPAM_UPDATE)
