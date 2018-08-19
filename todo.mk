# Provide a recipe to find capital "todo" lines in the project.

# Here is a custom todo tool, documented given its arcane invocation. If this
# had capital tee oh dee oh literally, `make todo` will list this file, which
# is a false positive. Instead, find actual todos in the project.
#
# The sed expression normalizes whitespace within one tab-stop, matching
# [^T\ODO]* to avoid .* chopping off lines. Dummy regular expression brackets
# [T] don't do anything to the grep call. Dummy escape \O is literal O, which
# is used to avoid matching this Makefile.
todo:
	@echo
	@echo "T"ODOs:
	@echo
	@git grep -n [T]ODO | sed 's/\([0-9]\):[^T\ODO]*T\ODO/\1:\tT\ODO/g'
	@echo
