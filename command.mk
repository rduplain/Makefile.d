# Check for a requisite command as a dependency target.

%-command:
	@which $* >/dev/null || ( echo "Requires '$*' command."; false )

.PHONY: %-command
