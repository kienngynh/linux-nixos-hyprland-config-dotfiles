#!/usr/bin/env bash
# =============================================================================
# NixOS First-Time Deployment Script
# =============================================================================
# This script sets up your system from a fresh NixOS install.
# Run with: sudo bash deploy.sh
#
# Prerequisites:
#   - Fresh NixOS installation with flakes enabled (or enable temporarily:
#     nix --experimental-features 'nix-command flakes' ...)
#   - Internet connection
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIXOS_SOURCE="${SCRIPT_DIR}/nixos"
HOME_SOURCE="${SCRIPT_DIR}/home"
NIXOS_TARGET="/etc/nixos"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
ok()    { echo -e "${GREEN}[ OK ]${NC} $1"; }
err()   { echo -e "${RED}[ERR ]${NC} $1"; }

# =============================================================================
# Step 1: Detect Hardware
# =============================================================================
detect_gpu() {
    info "Detecting GPU..."
    if lspci 2>/dev/null | grep -qi nvidia; then
        echo "nvidia"
    elif lspci 2>/dev/null | grep -qi "amd.*radeon\|amd.*graphics\|amd/ati"; then
        echo "amd"
    elif lspci 2>/dev/null | grep -qi "intel.*graphics\|intel.*uhd\|intel.*iris"; then
        echo "intel"
    else
        echo "unknown"
    fi
}

# =============================================================================
# Step 2: Interactive Configuration
# =============================================================================
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║       NixOS + Hyprland First-Time Setup         ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Read current username
CURRENT_USER="${SUDO_USER:-$(whoami)}"
read -rp "$(echo -e "${CYAN}Username${NC} [${CURRENT_USER}]: ")" INPUT_USER
USERNAME="${INPUT_USER:-$CURRENT_USER}"

# Read hostname
CURRENT_HOSTNAME="$(hostname)"
read -rp "$(echo -e "${CYAN}Hostname${NC} [${CURRENT_HOSTNAME}]: ")" INPUT_HOST
HOSTNAME="${INPUT_HOST:-$CURRENT_HOSTNAME}"

# Read stateVersion
DEFAULT_STATE_VERSION="24.11"
read -rp "$(echo -e "${CYAN}NixOS stateVersion${NC} [${DEFAULT_STATE_VERSION}]: ")" INPUT_SV
STATE_VERSION="${INPUT_SV:-$DEFAULT_STATE_VERSION}"

# Detect and confirm GPU
GPU_DETECTED=$(detect_gpu)
echo ""
info "Detected GPU: ${GPU_DETECTED}"
echo -e "  GPU profiles available: nvidia, intel, amd, vm, none"
read -rp "$(echo -e "${CYAN}GPU profile${NC} [${GPU_DETECTED}]: ")" INPUT_GPU
GPU_PROFILE="${INPUT_GPU:-$GPU_DETECTED}"

# Confirm profile
echo ""
echo "Choose deployment profile:"
echo "  1) minimal  — Desktop essentials only (fast, recommended for first deploy)"
echo "  2) full     — Everything: dev tools, AI/LLM, security, Rust"
read -rp "$(echo -e "${CYAN}Profile${NC} [1]: ")" INPUT_PROFILE
case "${INPUT_PROFILE:-1}" in
    2|full) PROFILE="full" ;;
    *)      PROFILE="minimal" ;;
esac

# Summary
echo ""
echo -e "${CYAN}━━━ Configuration Summary ━━━${NC}"
echo -e "  Username:      ${GREEN}${USERNAME}${NC}"
echo -e "  Hostname:      ${GREEN}${HOSTNAME}${NC}"
echo -e "  stateVersion:  ${GREEN}${STATE_VERSION}${NC}"
echo -e "  GPU:           ${GREEN}${GPU_PROFILE}${NC}"
echo -e "  Profile:       ${GREEN}${PROFILE}${NC}"
echo ""
read -rp "Proceed? [Y/n]: " CONFIRM
if [[ "${CONFIRM:-Y}" =~ ^[Nn] ]]; then
    err "Aborted."
    exit 1
fi

# =============================================================================
# Step 3: Update flake.nix with user values
# =============================================================================
info "Updating flake.nix with your configuration..."
FLAKE_FILE="${NIXOS_SOURCE}/flake.nix"

sed -i "s/username = \".*\"/username = \"${USERNAME}\"/" "$FLAKE_FILE"
sed -i "s/hostname = \".*\"/hostname = \"${HOSTNAME}\"/" "$FLAKE_FILE"
sed -i "s/stateVersion = \".*\"/stateVersion = \"${STATE_VERSION}\"/" "$FLAKE_FILE"
ok "flake.nix updated"

# =============================================================================
# Step 4: Generate hardware-configuration.nix if not present
# =============================================================================
if [ ! -f "${NIXOS_SOURCE}/hardware-configuration.nix" ]; then
    info "Generating hardware-configuration.nix..."
    nixos-generate-config --show-hardware-config > "${NIXOS_SOURCE}/hardware-configuration.nix"
    ok "hardware-configuration.nix generated"
else
    warn "hardware-configuration.nix already exists, skipping generation"
fi

# =============================================================================
# Step 5: Set up hardware profile in flake
# =============================================================================
if [ -f "${NIXOS_SOURCE}/hardware/${GPU_PROFILE}.nix" ]; then
    info "GPU profile '${GPU_PROFILE}' found"
else
    if [ "$GPU_PROFILE" != "none" ] && [ "$GPU_PROFILE" != "unknown" ]; then
        warn "GPU profile '${GPU_PROFILE}.nix' not found in hardware/, skipping GPU config"
    fi
fi

# =============================================================================
# Step 6: Copy nixos configs to /etc/nixos
# =============================================================================
info "Copying NixOS configuration to ${NIXOS_TARGET}..."
cp -r "${NIXOS_SOURCE}"/. "${NIXOS_TARGET}/"
chown -R root:root "${NIXOS_TARGET}"
ok "NixOS configuration copied to ${NIXOS_TARGET}"

# =============================================================================
# Step 7: Symlink home configs
# =============================================================================
USER_HOME="/home/${USERNAME}"
info "Setting up home directory configs for ${USERNAME}..."

# Copy home-level dotfiles that can't be symlinked easily before first build
for item in .gitconfig .gtkrc-2.0 .npmrc .face .nix-channels; do
    if [ -e "${HOME_SOURCE}/${item}" ]; then
        cp -a "${HOME_SOURCE}/${item}" "${USER_HOME}/${item}" 2>/dev/null || true
    fi
done

# Copy .config files (Home Manager will take over after first rebuild)
mkdir -p "${USER_HOME}/.config"
if [ -d "${HOME_SOURCE}/.config" ]; then
    cp -ra "${HOME_SOURCE}/.config"/. "${USER_HOME}/.config/"
fi

# Fix ownership
chown -R "${USERNAME}:users" "${USER_HOME}/.config" 2>/dev/null || true
chown -R "${USERNAME}:users" "${USER_HOME}/.gitconfig" 2>/dev/null || true

ok "Home configs set up"

# =============================================================================
# Step 8: Build
# =============================================================================
echo ""
info "Ready to build NixOS configuration!"
echo ""
echo "Run the following command to build:"
echo ""

if [ "$PROFILE" = "full" ]; then
    FLAKE_HOST="${HOSTNAME}-full"
else
    FLAKE_HOST="${HOSTNAME}"
fi

echo -e "  ${GREEN}sudo nixos-rebuild switch --flake ${NIXOS_TARGET}#${FLAKE_HOST}${NC}"
echo ""
read -rp "Build now? [Y/n]: " BUILD_CONFIRM
if [[ "${BUILD_CONFIRM:-Y}" =~ ^[Yy]$ ]] || [[ -z "${BUILD_CONFIRM}" ]]; then
    info "Building... (this may take a while on first build)"
    nixos-rebuild switch --flake "${NIXOS_TARGET}#${FLAKE_HOST}"
    echo ""
    ok "Build complete! Please reboot to apply all changes."
    echo -e "  Run: ${GREEN}sudo reboot${NC}"
else
    info "You can build later with:"
    echo -e "  ${GREEN}sudo nixos-rebuild switch --flake ${NIXOS_TARGET}#${FLAKE_HOST}${NC}"
fi

echo ""
ok "Setup complete!"
