#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Install DankMaterialShell with Niri compositor
# - Removes GNOME desktop components
# - Installs Niri and supporting portals
# - Installs DMS from the stable COPR with recommended extras
# - Enables DMS user service for all users
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Remove GNOME Desktop"

# Remove GNOME Shell and related packages
# This mirrors the pattern used in the COSMIC example
# and prepares the system for the Niri/DMS stack

dnf5 remove -y \
    gnome-shell \
    gnome-shell-extension* \
    gnome-terminal \
    gnome-software \
    gnome-control-center \
    nautilus \
    gdm

echo "GNOME desktop removed"
echo "::endgroup::"

echo "::group:: Install display manager for Niri"

# Install a lightweight display manager to replace GDM
# SDDM provides Wayland support and a session chooser

dnf5 install -y sddm
systemctl enable sddm

echo "Display manager installed and enabled"
echo "::endgroup::"

echo "::group:: Install Niri compositor and portals"

# Install Niri and basic Wayland/XDG integration

dnf5 install -y \
    niri \
    xdg-desktop-portal-wlr \
    accountsservice

echo "Niri compositor installed"
echo "::endgroup::"

echo "::group:: Install DankMaterialShell (stable COPR)"

# Install DMS and recommended extras from the documentation using the
# isolated COPR pattern to avoid leaving the COPR enabled
copr_install_isolated "avengemedia/dms" \
    dms \
    quickshell \
    cliphist \
    wl-clipboard \
    dgop \
    dsearch \
    matugen \
    cava \
    qt6-multimedia

echo "DankMaterialShell and extras installed"
echo "::endgroup::"

echo "::group:: Enable DMS user service for all users"

# Enable the user service globally so every user session starts DMS
# on login. Using a persistent symlink avoids relying on systemd running
# during the image build.
mkdir -p /etc/systemd/user/default.target.wants
ln -sf /usr/lib/systemd/user/dms.service /etc/systemd/user/default.target.wants/dms.service

echo "DMS user service enabled for all users"
echo "::endgroup::"

echo "DankMaterialShell with Niri installation complete"
