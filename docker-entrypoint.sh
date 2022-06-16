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

# Use "src" as default sources directory (override "src" value in book.toml)
export MDBOOK_BOOK__SRC="${MDBOOK_BOOK__SRC:-src}"

BUILD_TARGET="${1}"
if [ -n "${BUILD_TARGET}" ]; then
	echo "Using BUILD_TARGET=${BUILD_TARGET}"

	if [ ! -f "/data/src/SUMMARY-${BUILD_TARGET}.md" ]; then
		echo "ERROR: Target summary file '/data/src/SUMMARY-${BUILD_TARGET}.md' was not found. Maybe you pass wrong build target '${BUILD_TARGET}'?!" >&2
		exit 2
	fi

	if [ -f /data/src/SUMMARY.md ]; then
		rm /data/src/SUMMARY.md
	fi

	echo "Linking '/data/src/SUMMARY.md' -> 'SUMMARY-${BUILD_TARGET}.md'"
	ln -s "SUMMARY-${BUILD_TARGET}.md" /data/src/SUMMARY.md
else
	if [ ! -f /data/src/SUMMARY.md ]; then
		echo "ERROR: Target summary file '/data/src/SUMMARY.md' was not found. Maybe you miss to pass build target?!" >&2
		exit 2
	fi
fi

set -e

echo
echo "Launching 'mdbook-mermaid' to add the required files and configuration ..."
echo
mdbook-mermaid install /data/

echo
echo "Starting 'mdbook serve' to serve a book and rebuilds it on changes ..."
echo
exec mdbook serve --hostname 0.0.0.0 --port 8000 /data
