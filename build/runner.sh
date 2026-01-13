#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob

BUILD_DIR="/ctx/build"

# Determine releasever dynamically (e.g., Fedora 43)
releasever="${releasever:-}"
if [[ -z "${releasever}" ]]; then
	releasever="$(rpm -E %fedora 2>/dev/null || true)"
fi
if [[ -z "${releasever}" ]]; then
	releasever="$(rpm -E %rhel 2>/dev/null || true)"
fi
if [[ -z "${releasever}" && -r /etc/os-release ]]; then
	# shellcheck disable=SC1091
	. /etc/os-release
	releasever="${VERSION_ID:-}"
fi
if [[ -z "${releasever}" ]]; then
	echo "releasever is unset and could not be determined" >&2
	exit 1
fi
export releasever

for script in "${BUILD_DIR}"/[0-9][0-9]-*.sh; do
	case "$script" in
	*.example | *.disabled)
		echo "Skipping $(basename "$script") (example/disabled)"
		continue
		;;
	esac

	if [[ ! -x "$script" ]]; then
		echo "Skipping $(basename "$script") (not executable)"
		continue
	fi

	echo "==> Running $(basename "$script")"
	"$script"
done
