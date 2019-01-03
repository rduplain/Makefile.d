CLJS_NAME := hello

all: release

include .Makefile.d/cljs.mk

bin: cljs-bin
build: cljs-build
install: cljs-install
outdated: cljs-outdated
release: cljs-release
repl: cljs-repl
test-refresh: cljs-test-refresh
test: cljs-test

# Build a binary for FreeBSD using `release-for-os` on a FreeBSD system.
bin-for-os: cljs-bin-for-os
release-for-os: cljs-release-for-os
