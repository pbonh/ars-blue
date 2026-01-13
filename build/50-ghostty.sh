#!/bin/bash
set -ouex pipefail

# --- Ghostty via Terra (Fyralabs) repo/package ---
# Ghostty docs (Fedora -> Terra) install terra-release from Terra repo path, then install ghostty. :contentReference[oaicite:1]{index=1}

# 1) Add Terra repo by installing terra-release (initial install uses --nogpgcheck per docs) :contentReference[oaicite:2]{index=2}
dnf5 install -y \
  --nogpgcheck \
  --repofrompath="terra,https://repos.fyralabs.com/terra$releasever" \
  terra-release

# 2) Install Ghostty :contentReference[oaicite:3]{index=3}
dnf5 install -y ghostty

# Cleanup
dnf5 clean all
rm -rf /var/cache/dnf /var/cache/dnf5 || true

