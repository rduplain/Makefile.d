# Switch opam to project-local path, install deps with opam, build with dune.

OCAML_MK := $(lastword $(MAKEFILE_LIST))
DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

OCAML_REV ?= 4.09.0
DUNE_REV ?= 1.11.4

include $(DIR)/command.mk
include $(DIR)/path.mk

_OPAM := $(PROJECT_ROOT)/_opam
OCAML := $(_OPAM)/bin/ocaml
DUNE := $(_OPAM)/bin/dune

OPAM_INSTALL := $(_OPAM)/lib/.opam-install

# Re-create `eval $(opam env)`.
export OPAM_SWITCH_PREFIX := $(_OPAM)
export OCAML_TOPLEVEL_PATH := $(_OPAM)/lib/toplevel
export MANPATH := $(_OPAM)/man:$(MANPATH)
export PATH := $(_OPAM)/bin:$(PATH)

CAML_LD_LIBRARY_PATH := $(_OPAM)/lib/stublibs:$(_OPAM)/lib/ocaml/stublibs
CAML_LD_LIBRARY_PATH := $(CAML_LD_LIBRARY_PATH):$(_OPAM)/lib/ocaml
export CAML_LD_LIBRARY_PATH

ocaml-command: $(OCAML)
	@true

dune-command: $(DUNE)
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

$(DUNE): $(OCAML_MK) | $(OCAML)
	@opam update
	@opam install --yes dune.$(DUNE_REV)
	@touch $@

opam-install: $(OPAM_INSTALL) | $(OCAML)
	@true

$(OPAM_INSTALL): $(OCAML_MK) dune dune-project | dune-command
	@opam update
	@$(DUNE) build @install
	@opam install --yes --deps-only $(PROJECT_ROOT)
	@touch $@
