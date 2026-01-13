#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Install WezTerm (nightly) from COPR + optional font extras
# Reference: WezTerm docs (wezfurlong/wezterm-nightly COPR)
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Install WezTerm (nightly via COPR)"

# Use isolated COPR pattern to avoid persisting the repo
copr_install_isolated "wezfurlong/wezterm-nightly" \
    wezterm

echo "WezTerm installed"
echo "::endgroup::"

echo "::group:: Install optional terminal font extras"

# Useful mono/nerd-friendly fonts from main repos
# Adjust or extend as needed for your environment
DNF_OPTIONAL_FONTS=(
    fira-code-fonts
    jetbrains-mono-fonts
    powerline-fonts
)

dnf5 install -y "${DNF_OPTIONAL_FONTS[@]}"

echo "Optional fonts installed"
echo "::endgroup::"

echo "WezTerm setup complete"
