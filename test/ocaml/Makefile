all: utop-command test

include .Makefile.d/ocaml.mk

build: opam-install
	@$(DUNE) build hello.exe

test: build
	@_build/default/hello.exe
