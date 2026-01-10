# ars-blue

A custom bootc operating system based on [Universal Blue](https://universal-blue.org/) and [Bluefin](https://projectbluefin.io), designed as a general-purpose developer workstation featuring the [Niri](https://github.com/YaLTeR/niri) scrollable-tiling Wayland compositor and [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) desktop environment.

This is a customized bootc image built using the **multi-stage build architecture** from @projectbluefin/finpilot, combining resources from multiple OCI containers for modularity and maintainability.

> Be the one who moves, not the one who is moved.

## What Makes ars-blue Different?

ars-blue is a developer-focused operating system that replaces the traditional desktop environment with a modern, scrollable-tiling workflow centered around the Niri Wayland compositor and DankMaterialShell.

### Key Features

**Niri Scrollable-Tiling Window Manager**
- Scrollable tiling with windows arranged in columns on an infinite strip
- Dynamic workspaces like GNOME
- Built-in Overview mode that zooms out workspaces and windows
- Touchpad and mouse gestures for navigation
- Window tabs for grouping related windows
- Smooth animations with custom shader support

**DankMaterialShell Desktop Environment**
- Complete desktop shell built with Quickshell and Go
- Dynamic theming based on your wallpaper
- Unified control center for network, Bluetooth, audio, and display settings
- Spotlight-style launcher for applications, files, emojis, and commands
- MPRIS media controls and notification center
- Session management with lock screen and idle detection

**Developer Workstation**
- Pre-configured for development workflows
- Homebrew integration for CLI tools
- Flatpak support for GUI applications
- Optimized for keyboard-driven productivity

### What's Included

This image is based on **Universal Blue Silverblue** and includes:
- Niri scrollable-tiling Wayland compositor
- DankMaterialShell desktop environment
- Alacritty terminal emulator
- All standard Bluefin development tools
- Homebrew package management
- Flatpak application support

*Last updated: 2026-01-10*

## Guided Copilot Mode

Here are the steps to guide copilot to make your own repo, or just use it like a regular image template.

1. Click the green "Use this as a template" button and create a new repository
2. Select your owner, pick a repo name for your OS, and a description
3. In the "Jumpstart your project with Copilot (optional)" add this, modify to your liking:

```
Use @projectbluefin/finpilot as a template, name the OS the repository name. Ensure the entire operating system is bootstrapped. Ensure all github actions are enabled and running.  Ensure the README has the github setup instructions for cosign and the other steps required to finish the task.
```

> **Note**: ars-blue is already fully configured and ready to use. This section is for reference if you want to create your own custom OS based on this repository.

## What's Included

### Build System
- Automated builds via GitHub Actions on every commit
- Awesome self hosted Renovate setup that keeps all your images and actions up to date.
- Automatic cleanup of old images (90+ days) to keep it tidy
- Pull request workflow - test changes before merging to main
  - PRs build and validate before merge
  - `main` branch builds `:stable` images
- Validates your files on pull requests so you never break a build:
  - Brewfile, Justfile, ShellCheck, Renovate config, and it'll even check to make sure the flatpak you add exists on FlatHub
- Production Grade Features
  - Container signing and SBOM Generation
  - See checklist below to enable these as they take some manual configuration

### Homebrew Integration
- Pre-configured Brewfiles for easy package installation and customization
- Includes curated collections: development tools, fonts, CLI utilities. Go nuts.
- Users install packages at runtime with `brew bundle`, aliased to premade `ujust commands`
- See [custom/brew/README.md](custom/brew/README.md) for details

### Flatpak Support
- Ship your favorite flatpaks
- Automatically installed on first boot after user setup
- See [custom/flatpaks/README.md](custom/flatpaks/README.md) for details

### ujust Commands
- User-friendly command shortcuts via `ujust`
- Pre-configured examples for app installation and system maintenance for you to customize
- See [custom/ujust/README.md](custom/ujust/README.md) for details

### Build Scripts
- Modular numbered scripts (10-, 20-, 30-) run in order
- Example scripts included for third-party repositories and desktop replacement
- Helper functions for safe COPR usage
- See [build/README.md](build/README.md) for details

## Quick Start

### 1. GitHub Actions Setup

Enable GitHub Actions in your repository:

- Go to the "Actions" tab in your repository  
- Click "I understand my workflows, go ahead and enable them"

Your first build will start automatically! 

**Note**: Image signing is disabled by default. Your images will build successfully without any signing keys. Once you're ready for production, see "[Optional: Enable Image Signing](#optional-enable-image-signing)" below.

### 2. Deploy ars-blue

Switch to the ars-blue image:
```bash
sudo bootc switch ghcr.io/pbonh/ars-blue:stable
sudo systemctl reboot
```

After reboot, you'll be running ars-blue with Niri and DankMaterialShell!

#### First Login with Niri

1. At the login screen (GDM), click the gear icon ⚙️ at the bottom-right
2. Select "Niri" from the session options
3. Log in with your credentials

Niri will start with DankMaterialShell providing the complete desktop environment.

#### Essential Niri Keybindings

The default Mod key is <kbd>Super</kbd> (Windows key).

| Hotkey | Action |
|--------|--------|
| <kbd>Mod</kbd>+<kbd>T</kbd> | Open terminal (Alacritty) |
| <kbd>Mod</kbd>+<kbd>D</kbd> | Open application launcher |
| <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>/</kbd> | Show keybinding help |
| <kbd>Mod</kbd>+<kbd>Q</kbd> | Close focused window |
| <kbd>Mod</kbd>+<kbd>H</kbd>/<kbd>L</kbd> | Focus column left/right |
| <kbd>Mod</kbd>+<kbd>J</kbd>/<kbd>K</kbd> | Focus window down/up |
| <kbd>Mod</kbd>+<kbd>F</kbd> | Maximize column |
| <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd> | Exit Niri |

For the complete list of keybindings and configuration, see:
- [Niri Documentation](https://yalter.github.io/niri/)
- [DankMaterialShell Documentation](https://danklinux.com/docs)

### 3. Optional: Customize Your Image

If you want to customize ars-blue for your needs, make changes via pull requests:

1. Open a pull request on GitHub with the change you want.
2. The PR will automatically trigger:
   - Build validation
   - Brewfile, Flatpak, Justfile, and shellcheck validation
   - Test image build
3. Once checks pass, merge the PR
4. Merging triggers and publishes a `:stable` image

## Optional: Enable Image Signing

Image signing is disabled by default to let you start building immediately. However, signing is strongly recommended for production use.

### Why Sign Images?

- Verify image authenticity and integrity
- Prevent tampering and supply chain attacks
- Required for some enterprise/security-focused deployments
- Industry best practice for production images

### Setup Instructions

1. Generate signing keys:
```bash
cosign generate-key-pair
```

This creates two files:
- `cosign.key` (private key) - Keep this secret
- `cosign.pub` (public key) - Commit this to your repository

2. Add the private key to GitHub Secrets:
   - Copy the entire contents of `cosign.key`
   - Go to your repository on GitHub
   - Navigate to Settings → Secrets and variables → Actions ([GitHub docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository))
   - Click "New repository secret"
   - Name: `SIGNING_SECRET`
   - Value: Paste the entire contents of `cosign.key`
   - Click "Add secret"

3. Replace the contents of `cosign.pub` with your public key:
   - Open `cosign.pub` in your repository
   - Replace the placeholder with your actual public key
   - Commit and push the change

4. Enable signing in the workflow:
   - Edit `.github/workflows/build.yml`
   - Find the "OPTIONAL: Image Signing with Cosign" section.
   - Uncomment the steps to install Cosign and sign the image (remove the `#` from the beginning of each line in that section).
   - Commit and push the change

5. Your next build will produce signed images!

Important: Never commit `cosign.key` to the repository. It's already in `.gitignore`.

## Love Your Image? Let's Go to Production

Ready to take your custom OS to production? Enable these features for enhanced security, reliability, and performance:

### Production Checklist

- [ ] **Enable Image Signing** (Recommended)
  - Provides cryptographic verification of your images
  - Prevents tampering and ensures authenticity
  - See "Optional: Enable Image Signing" section above for setup instructions
  - Status: **Disabled by default** to allow immediate testing

- [ ] **Enable SBOM Attestation** (Recommended)
  - Generates Software Bill of Materials for supply chain security
  - Provides transparency about what's in your image
  - Requires image signing to be enabled first
  - To enable:
    1. First complete image signing setup above
    2. Edit `.github/workflows/build.yml`
    3. Find the "OPTIONAL: SBOM Attestation" section around line 232
    4. Uncomment the "Add SBOM Attestation" step
    5. Commit and push
  - Status: **Disabled by default** (requires signing first)

- [ ] **Enable Image Rechunking** (Recommended)
  - Optimizes bootc image layers for better update performance
  - Reduces update sizes by 5-10x
  - Improves download resumability with evenly sized layers
  - To enable:
    1. Edit `.github/workflows/build.yml`
    2. Find the "Build Image" step
    3. Add a rechunk step after the build (see example below)
  - Status: **Not enabled by default** (optional optimization)

#### Adding Image Rechunking

After building your bootc image, add a rechunk step before pushing to the registry. Here's an example based on the workflow used by [zirconium-dev/zirconium](https://github.com/zirconium-dev/zirconium):

```yaml
- name: Build image
  id: build
  run: sudo podman build -t "${IMAGE_NAME}:${DEFAULT_TAG}" -f ./Containerfile .

- name: Rechunk Image
  run: |
    sudo podman run --rm --privileged \
      -v /var/lib/containers:/var/lib/containers \
      --entrypoint /usr/libexec/bootc-base-imagectl \
      "localhost/${IMAGE_NAME}:${DEFAULT_TAG}" \
      rechunk --max-layers 96 \
      "localhost/${IMAGE_NAME}:${DEFAULT_TAG}" \
      "localhost/${IMAGE_NAME}:${DEFAULT_TAG}"

- name: Push to Registry
  run: sudo podman push "localhost/${IMAGE_NAME}:${DEFAULT_TAG}" "${IMAGE_REGISTRY}/${IMAGE_NAME}:${DEFAULT_TAG}"
```

Alternative approach using a temporary tag for clarity:

```yaml
- name: Rechunk Image
  run: |
    sudo podman run --rm --privileged \
      -v /var/lib/containers:/var/lib/containers \
      --entrypoint /usr/libexec/bootc-base-imagectl \
      "localhost/${IMAGE_NAME}:${DEFAULT_TAG}" \
      rechunk --max-layers 67 \
      "localhost/${IMAGE_NAME}:${DEFAULT_TAG}" \
      "localhost/${IMAGE_NAME}:${DEFAULT_TAG}-rechunked"
    
    # Tag the rechunked image with the original tag
    sudo podman tag "localhost/${IMAGE_NAME}:${DEFAULT_TAG}-rechunked" "localhost/${IMAGE_NAME}:${DEFAULT_TAG}"
    sudo podman rmi "localhost/${IMAGE_NAME}:${DEFAULT_TAG}-rechunked"
```

**Parameters:**
- `--max-layers`: Maximum number of layers for the rechunked image (typically 67 for optimal balance)
- The first image reference is the source (input)
- The second image reference is the destination (output)
  - When using the same reference for both, the image is rechunked in-place
  - You can also use different tags (e.g., `-rechunked` suffix) and then retag if preferred

**References:**
- [CoreOS rpm-ostree build-chunked-oci documentation](https://coreos.github.io/rpm-ostree/build-chunked-oci/)
- [bootc documentation](https://containers.github.io/bootc/)

### After Enabling Production Features

Your workflow will:
- Sign all images with your key
- Generate and attach SBOMs
- Provide full supply chain transparency

Users can verify your images with:
```bash
cosign verify --key cosign.pub ghcr.io/pbonh/ars-blue:stable
```

## Detailed Guides

- [Homebrew/Brewfiles](custom/brew/README.md) - Runtime package management
- [Flatpak Preinstall](custom/flatpaks/README.md) - GUI application setup
- [ujust Commands](custom/ujust/README.md) - User convenience commands
- [Build Scripts](build/README.md) - Build-time customization

## Architecture

This template follows the **multi-stage build architecture** from @projectbluefin/distroless, as documented in the [Bluefin Contributing Guide](https://docs.projectbluefin.io/contributing/).

### Multi-Stage Build Pattern

**Stage 1: Context (ctx)** - Combines resources from multiple sources:
- Local build scripts (`/build`)
- Local custom files (`/custom`)
- **@projectbluefin/common** - Desktop configuration shared with Aurora
- **@projectbluefin/branding** - Branding assets
- **@ublue-os/artwork** - Artwork shared with Aurora and Bazzite
- **@ublue-os/brew** - Homebrew integration

**Stage 2: Base Image** - Default options:
- `ghcr.io/ublue-os/silverblue-main:latest` (Fedora-based, default)
- `quay.io/centos-bootc/centos-bootc:stream10` (CentOS-based alternative)

### Benefits of This Architecture

- **Modularity**: Compose your image from reusable OCI containers
- **Maintainability**: Update shared components independently
- **Reproducibility**: Renovate automatically updates OCI tags to SHA digests
- **Consistency**: Share components across Bluefin, Aurora, and custom images

### OCI Container Resources

The template imports files from these OCI containers at build time:

```dockerfile
COPY --from=ghcr.io/ublue-os/base-main:latest /system_files /oci/base
COPY --from=ghcr.io/projectbluefin/common:latest /system_files /oci/common
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /oci/brew
```

Your build scripts can access these files at:
- `/ctx/oci/base/` - Base system configuration
- `/ctx/oci/common/` - Shared desktop configuration
- `/ctx/oci/branding/` - Branding assets
- `/ctx/oci/artwork/` - Artwork files
- `/ctx/oci/brew/` - Homebrew integration files

**Note**: Renovate automatically updates `:latest` tags to SHA digests for reproducible builds.

## Local Testing

Test your changes before pushing:

```bash
just build              # Build container image
just build-qcow2        # Build VM disk image
just run-vm-qcow2       # Test in browser-based VM
```

## Troubleshooting

### Niri doesn't appear in login screen

Make sure you selected "Niri" from the session options (gear icon at bottom-right of GDM login screen).

If Niri is not listed:
1. Check that the build completed successfully
2. Verify niri package was installed: `rpm -qa | grep niri`
3. Check for the niri.desktop file: `ls -l /usr/share/wayland-sessions/niri.desktop`

### DankMaterialShell isn't starting

DMS should start automatically with Niri. If it doesn't:

1. Check DMS service status:
   ```bash
   systemctl --user status dms
   ```

2. Enable DMS service manually:
   ```bash
   systemctl --user enable --now dms
   ```

3. Check DMS logs:
   ```bash
   journalctl --user -u dms
   ```

### Black screen when starting Niri

This can happen on some GPU configurations. Try setting the render device manually:

1. Find your render device:
   ```bash
   ls -l /dev/dri/
   ```

2. Edit `~/.config/niri/config.kdl` and add:
   ```kdl
   debug {
       render-drm-device "/dev/dri/renderD128"
   }
   ```

For more help:
- [Niri Matrix Chat](https://matrix.to/#/#niri:matrix.org)
- [DankMaterialShell Documentation](https://danklinux.com/docs)
- [Universal Blue Discord](https://discord.gg/WEu6BdFEtp)

## Community

### ars-blue & Components

- [Niri Matrix Chat](https://matrix.to/#/#niri:matrix.org) - Get help with Niri
- [DankMaterialShell Discord](https://discord.gg/vT8Sfjy7sx) - DMS community support

### Universal Blue & bootc

- [Universal Blue Discord](https://discord.gg/WEu6BdFEtp)
- [bootc Discussion](https://github.com/bootc-dev/bootc/discussions)

## Learn More

### ars-blue Components

- [Niri Window Manager](https://github.com/YaLTeR/niri) - Scrollable-tiling Wayland compositor
- [Niri Documentation](https://yalter.github.io/niri/) - Configuration and usage guide
- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) - Desktop shell for Wayland
- [DankMaterialShell Docs](https://danklinux.com/docs) - DMS configuration and plugins

### Universal Blue & bootc

- [Universal Blue Documentation](https://universal-blue.org/)
- [bootc Documentation](https://containers.github.io/bootc/)
- [Video Tutorial by TesterTech](https://www.youtube.com/watch?v=IxBl11Zmq5wE)

## Security

This template provides security features for production use:
- Optional SBOM generation (Software Bill of Materials) for supply chain transparency
- Optional image signing with cosign for cryptographic verification
- Automated security updates via Renovate
- Build provenance tracking

These security features are disabled by default to allow immediate testing. When you're ready for production, see the "Love Your Image? Let's Go to Production" section above to enable them.
