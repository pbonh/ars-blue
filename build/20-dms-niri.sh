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

echo "::group:: Install Niri compositor and portals"

# Install Niri and basic Wayland/XDG integration

dnf5 install -y \
    xdg-desktop-portal-wlr \
    accountsservice
    # niri \

echo "Niri compositor installed"
echo "::endgroup::"

echo "::group:: Install DankMaterialShell (stable COPR)"

# Install DMS and recommended extras from the documentation using the
# isolated COPR pattern to avoid leaving the COPR enabled
copr_install_isolated "avengemedia/danklinux" \
    quickshell \
    matugen \
    dms-greeter \
    niri
copr_install_isolated "avengemedia/dms" dms
# copr_install_isolated "avengemedia/danklinux" \
#     dms \
#     dms-cli \
#     dgop \
#     danksearch \
#     dank-greeter \
#     dms-color-picker \
#     dmsclipboard \
#     cli11 \
#     cliphist \
#     quickshell \
#     wl-clipboard \
#     matugen \
#     cava \
#     qt6-multimedia

# breakpad
# cli11
# cliphist
# danksearch
# dgop
# dms-greeter
# ghostty
# material-symbols-fonts
# matugen
# quickshell

echo "DankMaterialShell and extras installed"
echo "::endgroup::"

echo "::group:: Enable DMS user service for all users"

# Ensure user unit wants directories exist and enable DMS globally
install -d /etc/systemd/user/default.target.wants /etc/systemd/user/niri.service.wants
systemctl --global enable dms.service
systemctl --global add-wants niri.service dms.service

echo "DMS user service enabled for all users"
echo "::endgroup::"

echo "::group:: Configure greetd with dms-greeter"

dnf5 install -y greetd

install -d /etc/greetd
cat > /etc/greetd/config.toml <<'EOF'
[terminal]
vt = 1

[default_session]
user = "greeter"
command = "dms-greeter --command niri"
EOF

install -d -m 755 -o greeter -g greeter /var/cache/dms-greeter

systemctl disable gdm.service lightdm.service sddm.service || true
systemctl enable greetd

echo "greetd configured for dms-greeter"
echo "::endgroup::"

echo "DankMaterialShell with Niri installation complete"
