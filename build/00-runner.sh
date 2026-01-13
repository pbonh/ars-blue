#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob

BUILD_DIR="/ctx/build"

for script in "${BUILD_DIR}"/[0-9][0-9]-*.sh; do
  case "$script" in
    *.example|*.disabled)
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
