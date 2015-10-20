# Here is a custom todo tool, documented clearly so you know it works.
# If we write capital tee oh dee oh literally, `make todo` will list Makefile.
# We don't want that.  We want to find actual todos in the project.
# The sed expression below normalizes whitespace within one tab-stop.
# In the sed expression, we match [^T\ODO]* to avoid .* chopping off lines.
# Dummy regular expression brackets [T] don't do anything to our grep call.
# Dummy escape \O is literal O, which is used to avoid matching Makefile.
todo:
	@echo
	@echo "T"ODOs:
	@echo
	@git grep -n [T]ODO | sed 's/\([0-9]\):[^T\ODO]*T\ODO/\1:\tT\ODO/g'
	@echo
