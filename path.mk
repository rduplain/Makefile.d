# Export project root (directory of the Makefile with include) as PROJECT_ROOT.

DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
PROJECT_ROOT := $(abspath $(dir $(abspath $(DIR))))

export PROJECT_ROOT
