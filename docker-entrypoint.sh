#!/bin/sh
#

#
# See
# - include does not work in SUMMARY.md https://github.com/rust-lang/mdBook/issues/1116
#


# Following guard prevents to stuck mdBook (ignore SIGINT/Ctrl+C)
if [ $$ -eq 1 ]; then
	# Docker does not allow kill process 1, so restart as child process

	function ctrl_c() {
		echo "Killing process: $THE_PID"
		kill "${THE_PID}" 2>/dev/null
		sleep 3
		kill -9 "${THE_PID}" 2>/dev/null
	}

	# trap ctrl-c and call ctrl_c()
	trap ctrl_c SIGINT

	$0 "$@" &
	THE_PID=$!
	wait "${THE_PID}"
	exit $?
fi

# Use "public" as default deployment zone
DEPLOYMENT_ZONE="${1:-public}"

# Use "src" as default sources directory (override "src" value in book.toml)
export MDBOOK_BOOK__SRC="${MDBOOK_BOOK__SRC:-src}"

if [ ! -f "/data/src/SUMMARY-${DEPLOYMENT_ZONE}.md" ]; then
	echo "Summary file /data/src/SUMMARY-${DEPLOYMENT_ZONE}.md was not found." >&2
	exit 2
fi

if [ -f /data/src/SUMMARY.md ]; then
	rm /data/src/SUMMARY.md
fi

ln -s "SUMMARY-${DEPLOYMENT_ZONE}.md" /data/src/SUMMARY.md

exec mdbook serve --hostname 0.0.0.0 --port 8000 /data

