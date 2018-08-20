## Developer Tasks

run: Procfile | poorman-command
	$(POORMAN) start

prove-python: python-command
	$(PYTHON) -c 'import pip; print(pip.__version__)'
	$(PYTHON) -c 'import jeni; print(jeni.__version__)'

python-repl: python-command
	$(PYTHON)

# Run `make python-requirements` to install updates after changing this.
PYTHON_REQUIREMENTS := pip jeni


## Run Recipes w/Automated Requirements

include .Makefile.d/command.mk
include .Makefile.d/path.mk
include .Makefile.d/poorman.mk
include .Makefile.d/procfile.mk
include .Makefile.d/python.mk
include .Makefile.d/reqd.mk
include .Makefile.d/todo.mk
include .Makefile.d/wait.mk

Procfile: proc proc-redis proc-redis-cli
.PHONY: Procfile

REDIS_PORT := 7777

run-redis: reqd-redis
	$(REQD_PREFIX)/bin/redis-server --port $(REDIS_PORT)

run-redis-cli: wait-tcp-$(REDIS_PORT)
	./bin/repeat 10 $(REQD_PREFIX)/bin/redis-cli -p $(REDIS_PORT) incr counter
