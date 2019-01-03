# Provide ClojureScript workflow using Clojure CLI, Node.js/npm, & shadow-cljs.
#
# Set CLJS_NAME to the basename of the ClojureScript project, i.e. the name
# matching BASENAME.js build output and the name of the pkg-built executable.
#
# Supporting files to include at PROJECT_ROOT:
#
# * deps.edn with Clojure/ClojureScript dependencies and :test alias which adds
#   test path(s) to :extra-paths.
# * package.json with npm dependencies.
# * shadow-cljs.edn with :app, :test, and :test-refresh builds.

DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)/command.mk
include $(DIR)/echo.mk
include $(DIR)/path.mk

ifeq ($(CLJS_NAME),)
$(error Set CLJS_NAME to basename of ClojureScript project.)
endif


### Recipes ###

cljs-bin: cljs-install cljs-build pkg-renamed
cljs-build: cljs-install echo-building shadow-cljs-release-app
cljs-install: echo-clj clj-install echo-npm npm-install
cljs-outdated: cljs-install clj-outdated npm-outdated
cljs-release: cljs-install cljs-test cljs-bin cljs-test-bin
cljs-repl: cljs-install shadow-cljs-repl-app
cljs-test-refresh: cljs-install shadow-cljs-watch-test-refresh
cljs-test: cljs-install echo-testing shadow-cljs-test

# Build a binary for FreeBSD using `cljs-release-for-os` on a FreeBSD system.
cljs-bin-for-os: cljs-install cljs-build pkg-for-os
cljs-release-for-os: cljs-install cljs-test cljs-bin-for-os cljs-test-bin


### Clojure ###

clj-%: clojure-command
	@clojure -A$*

clj-install: .clj-install
	@true # Override wildcard recipe.

clj-test-refresh: clojure-command
	@clojure -Atest --watch src

.clj-install: deps.edn | clojure-command
	@clojure -Stree
	@touch $@


### Node.js ###

npm-%: npm-command
	@npm $*

npm-command: original-npm-command
	@true # Override wildcard recipe.

npm-install: .npm-install
	@true # Override wildcard recipe.

.npm-install: package.json | npm-command
	@npm install
	@npm ls --depth=0
	@touch $@

shadow-cljs-%-app: npm-install
	@./node_modules/.bin/shadow-cljs --force-spawn $* app

shadow-cljs-repl-app: npm-install
	@echo "Run this in a separate terminal:"
	@echo
	@echo "    node ./target/$(CLJS_NAME).js"
	@echo
	@./node_modules/.bin/shadow-cljs --force-spawn cljs-repl app

shadow-cljs-test: shadow-cljs-compile-test | npm-install
	@node ./target/test.js

shadow-cljs-%-test: npm-install
	@./node_modules/.bin/shadow-cljs --force-spawn $* test -A:test

shadow-cljs-%-test-refresh: npm-install
	@./node_modules/.bin/shadow-cljs --force-spawn $* test-refresh -A:test

pkg: npm-install
	@echo "building binaries ..."
	@./node_modules/.bin/pkg \
		-c package.json \
		-t node10-alpine-x64,node10-linux-x64,node10-mac-x64,node10-win-x64 \
		--out-path ./target/pkg \
		./target/$(CLJS_NAME).js

pkg-for-os: npm-install
	@echo "building binary ..."
	@./node_modules/.bin/pkg \
		-c package.json \
		-t node10 \
		--output ./target/$(CLJS_NAME) \
		./target/$(CLJS_NAME).js

pkg-renamed: pkg
	@mkdir -p ./target/bin-alpine
	@mv ./target/pkg/$(CLJS_NAME)-alpine ./target/bin-alpine/$(CLJS_NAME)
	@mkdir -p ./target/bin-linux
	@mv ./target/pkg/$(CLJS_NAME)-linux ./target/bin-linux/$(CLJS_NAME)
	@mkdir -p ./target/bin-mac
	@mv ./target/pkg/$(CLJS_NAME)-macos ./target/bin-mac/$(CLJS_NAME)
	@mkdir -p ./target/bin-windows
	@mv ./target/pkg/$(CLJS_NAME)-win.exe ./target/bin-windows/$(CLJS_NAME).exe
	@rm -fr ./target/pkg/
	@echo "-- redistributable binaries --"
	@find ./target/bin-* -type f | sort

cljs-test-bin:
	@echo "-- testing redistributable binary --"
	@env NAME=$(CLJS_NAME) $(DIR)/bin/find-and-run-test-suite $(PROJECT_ROOT)
