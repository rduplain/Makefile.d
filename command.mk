# Check for a requisite command as a dependency target.

define which
@which $* >/dev/null || ( echo "Requires '$*' command."; false )
endef

# Provide a means to depend on the original implementation of %-command when
# inside a .mk include which overloads the %-command pattern.
original-%-command:
	$(which)

%-command:
	$(which)

.PHONY: %-command original-%-command
