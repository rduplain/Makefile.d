# Provide a local Python environment for package installation.
#
# Supports Python 3.4+.

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(DIR)/command.mk
include $(DIR)/path.mk

# reqd is not required, but use its conventional location.
PYTHON_ENV_NAME := python
PYTHON_ENV := $(PROJECT_ROOT)/.reqd/opt/$(PYTHON_ENV_NAME)
PYTHON := $(PYTHON_ENV)/bin/python
PIP3 := $(PYTHON_ENV)/bin/pip3
PIP := $(PYTHON_ENV)/bin/pip

PIP_INSTALLED := $(PYTHON_ENV)/bin/.pip-installed

export PATH := $(PYTHON_ENV)/bin:$(PATH)

# Provide a space delimited list of requirements with PYTHON_REQUIREMENTS.
# Defaults to pip as a no-op.
ifeq ($(PYTHON_REQUIREMENTS),)
PYTHON_REQUIREMENTS := pip
endif

$(PYTHON): | original-python3-command
	@python3 --version
	@mkdir -p $(dir $(PYTHON_ENV))
	@echo 'Verifying not in a virtualenv (which would lead to errors) ...'
	@python3 -c 'import sys; sys.exit(int(sys.base_prefix!=sys.prefix))'
	@echo 'Continuing ...'
	@cd $(dir $(PYTHON_ENV)); python3 -m venv --clear $(PYTHON_ENV_NAME)
	@$(PYTHON) -m ensurepip --default-pip
	@$(PIP3) install --upgrade pip
	@$(PIP) install $(PYTHON_REQUIREMENTS)

python-requirements:
	@$(PIP) install --upgrade $(PYTHON_REQUIREMENTS)

# Replace command.mk's `python-command` to install virtualenv.
python-command: $(PYTHON) $(PIP_INSTALLED)
	@true

python3-command: $(PYTHON) $(PIP_INSTALLED)
	@true

# In a Makefile which includes this .mk, set REQUIREMENTS_TXT or MAKEFILE
# before the include statement. This will set a dependency so that any changes
# will cause pip to reinstall requirements, which will allow the Makefile to
# set PYTHON_REQUIREMENTS and have any changes to that variable take effect.
#
# In a Makefile, before including this python.mk:
#
#     REQUIREMENTS_TXT := requirements.txt
#
# ... or control the requirements directly in a Makefile variable:
#
#     REQUIREMENTS := pip==18.0 pyflakes
#     PYTHON_REQUIREMENTS_MAKEFILE := $(lastword $(MAKEFILE_LIST))
ifdef REQUIREMENTS_TXT
$(PIP_INSTALLED): $(REQUIREMENTS_TXT)
	@$(PIP) install --upgrade -r $(REQUIREMENTS_TXT)
	@touch $@
else ifdef PYTHON_REQUIREMENTS_TXT
$(PIP_INSTALLED): $(PYTHON_REQUIREMENTS_TXT)
	@$(PIP) install --upgrade -r $(PYTHON_REQUIREMENTS_TXT)
	@touch $@
else ifdef PYTHON_REQUIREMENTS_MAKEFILE
$(PIP_INSTALLED): $(PYTHON_REQUIREMENTS_MAKEFILE)
	@$(PIP) install --upgrade $(PYTHON_REQUIREMENTS)
	@touch $@
else
$(PIP_INSTALLED): $(PYTHON)
endif

clean-python-env:
	rm -fr $(PYTHON_ENV)
