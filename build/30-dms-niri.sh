#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Install DankMaterialShell + Niri stack using COPR packages
# This script removes GNOME, installs DMS and all optional dependencies, and
# configures greetd with a Niri session.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Remove GNOME Desktop"

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

echo "::group:: Install DankMaterialShell and optional dependencies"

# Install DMS and optional components from the stable COPR
copr_install_isolated "avengemedia/dms" \
    dms \
    quickshell \
    dsearch \
    dgop \
    matugen \
    cliphist \
    wl-clipboard \
    cava

# Remaining optional components available in Fedora/CentOS repos
# - niri: preferred compositor for DMS
# - qt6-multimedia: sound feedback
# - i2c-tools: monitor backlight control via DDC
# - accountsservice: persist user profile metadata
# - greetd + tuigreet: lightweight display manager
# - misc utilities already listed above
# shellcheck disable=SC2034
DNF_OPTIONAL_PACKAGES=(
    niri
    qt6-multimedia
    i2c-tools
    accountsservice
    greetd
    tuigreet
)

dnf5 install -y "${DNF_OPTIONAL_PACKAGES[@]}"

echo "DankMaterialShell stack installed"
echo "::endgroup::"

echo "::group:: Configure greetd for Niri"

mkdir -p /etc/greetd
cat > /etc/greetd/config.toml <<'GREETD_CONF'
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --cmd 'niri-session'"
user = "greeter"
GREETD_CONF

# Enable greetd and set graphical target
systemctl enable greetd
systemctl set-default graphical.target

echo "greetd configured for Niri"
echo "::endgroup::"

echo "::group:: Register Niri session"

mkdir -p /usr/share/wayland-sessions
cat > /usr/share/wayland-sessions/niri.desktop <<'NIRIDESKTOP'
[Desktop Entry]
Name=Niri (DankMaterialShell)
Comment=Tiling Wayland compositor with DankMaterialShell
Exec=niri-session
Type=Application
DesktopNames=niri
NIRIDESKTOP

echo "Niri session registered"
echo "::endgroup::"

echo "::group:: Bind DMS to Niri (user wants)"

# Pre-create user wants symlink so DMS starts with Niri sessions (no manual add-wants needed)
mkdir -p /usr/lib/systemd/user/niri.service.wants
ln -sf ../dms.service /usr/lib/systemd/user/niri.service.wants/dms.service

echo "User wants symlink created for dms.service under niri.service"
echo "::endgroup::"

echo "DankMaterialShell + Niri installation complete"
