#!/bin/bash
set -ouex pipefail

# --- Proton Mail (Linux Desktop app) via official RPM ---
# Proton publishes the RPM at this stable URL:
PROTON_RPM_URL="https://proton.me/download/mail/linux/ProtonMail-desktop-beta.rpm"
PROTON_RPM_PATH="/tmp/ProtonMail-desktop-beta.rpm"

# Ensure tools exist (many bases already have these; harmless if already present)
dnf5 install -y curl coreutils

# Download RPM
curl -fsSL "${PROTON_RPM_URL}" -o "${PROTON_RPM_PATH}"

# Optional but recommended: verify checksum.
# Proton documents sha512 verification and points to their version.json for the current SHA512. :contentReference[oaicite:5]{index=5}
# echo "<SHA512CheckSum>  ${PROTON_RPM_PATH}" | sha512sum --check -

# Install RPM (mirrors "sudo dnf install ./ProtonMail-desktop-beta.rpm") :contentReference[oaicite:6]{index=6}
dnf5 install -y "${PROTON_RPM_PATH}"

# Cleanup
rm -f "${PROTON_RPM_PATH}"
dnf5 clean all
rm -rf /var/cache/dnf /var/cache/dnf5 || true
