#!/bin/bash
set -ouex pipefail

# --- Brave Browser via official RPM repo ---
# Channels: release | beta | nightly
BRAVE_CHANNEL="${BRAVE_CHANNEL:-release}"

case "${BRAVE_CHANNEL}" in
  release)
    BRAVE_REPO_URL="https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo"
    BRAVE_REPO_PATH="/etc/yum.repos.d/brave-browser.repo"
    BRAVE_PKG="brave-browser"
    ;;
  beta)
    BRAVE_REPO_URL="https://brave-browser-rpm-beta.s3.brave.com/brave-browser-beta.repo"
    BRAVE_REPO_PATH="/etc/yum.repos.d/brave-browser-beta.repo"
    BRAVE_PKG="brave-browser-beta"
    ;;
  nightly)
    BRAVE_REPO_URL="https://brave-browser-rpm-nightly.s3.brave.com/brave-browser-nightly.repo"
    BRAVE_REPO_PATH="/etc/yum.repos.d/brave-browser-nightly.repo"
    BRAVE_PKG="brave-browser-nightly"
    ;;
  *)
    echo "Unknown BRAVE_CHANNEL='${BRAVE_CHANNEL}' (use: release|beta|nightly)" >&2
    exit 1
    ;;
esac

# Ensure curl exists
dnf5 install -y curl

# Add the official Brave RPM repo (Brave’s Atomic instructions fetch the repo file directly) :contentReference[oaicite:2]{index=2}
curl -fsSLo "${BRAVE_REPO_PATH}" "${BRAVE_REPO_URL}"

# Install Brave (Fedora 41+ docs: add repo then dnf install brave-browser) :contentReference[oaicite:3]{index=3}
dnf5 install -y "${BRAVE_PKG}"

# Cleanup
dnf5 clean all
rm -rf /var/cache/dnf /var/cache/dnf5 || true
