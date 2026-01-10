#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Main Build Script - ars-blue
###############################################################################
# This script installs Niri scrollable-tiling Wayland compositor and
# DankMaterialShell desktop environment for ars-blue OS.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/
cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/

# Consolidate Just Files
mkdir -p /usr/share/ublue-os/just/
find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/

echo "::endgroup::"

echo "::group:: Install Niri and DankMaterialShell"

# Install Niri and DankMaterialShell from avengemedia/dms COPR
# Using isolated COPR pattern to ensure repository is disabled after install
copr_install_isolated "avengemedia/dms" \
    niri \
    dms \
    xwayland-satellite \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-gtk \
    alacritty \
    wl-clipboard \
    cliphist \
    cava \
    matugen

echo "::endgroup::"

echo "::group:: Configure Niri as Default Session"

# Enable DMS service to start with Niri
# Note: This requires systemd user session, which will be set up on first boot
# The actual systemctl --user command will be run by users after first login

# Create a system-wide service enablement file for reference
mkdir -p /etc/systemd/user/niri.service.wants
ln -sf /usr/lib/systemd/user/dms.service /etc/systemd/user/niri.service.wants/dms.service

echo "::endgroup::"

echo "::group:: System Configuration"

# Enable/disable systemd services
systemctl enable podman.socket

# GDM should already be enabled in the base image
# Niri will be available as a session option in GDM

echo "::endgroup::"

echo "ars-blue build complete! Niri + DankMaterialShell installed."
