include .Makefile.d/path.mk

# Change 'master' to a release tag as desired.
.Makefile.d/%.mk:
	@git clone -b master https://github.com/rduplain/Makefile.d.git .Makefile.d

prove-Makefile.d:
	@echo $(PROJECT_ROOT)
