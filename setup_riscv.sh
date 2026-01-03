#!/usr/bin/env bash
# ============================================================================
#  PicoRV32 / RISC-V Toolchain Setup Script
# ----------------------------------------------------------------------------
#  Author      : Farag Elsayed
#  Date        : 2026-01-03
# ----------------------------------------------------------------------------
#  Description :
#  Automates the setup of nix-portable and triggers the download and build
#  process for the RISC-V toolchain within the pure Nix environment.
# ============================================================================

set -euo pipefail

# 1. Setup Nix Portable
NIX_PORTABLE_DIR="$HOME/.nix-portable"
NIX_PORTABLE="$NIX_PORTABLE_DIR/nix-portable"

if [ ! -x "$NIX_PORTABLE" ]; then
    echo "Downloading nix-portable..."
    mkdir -p "$NIX_PORTABLE_DIR"
    curl -L "https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m)" \
        -o "$NIX_PORTABLE"
    chmod +x "$NIX_PORTABLE"

    echo "✅ nix-portable downloaded to $NIX_PORTABLE"
    echo "💡 Optionally add this directory to your PATH:"
    echo "   export PATH=\"$NIX_PORTABLE_DIR:\$PATH\""
else
    echo "✅ nix-portable already exists at $NIX_PORTABLE"
fi

# Helper function to run nix-portable commands
function nixp() {
    "$NIX_PORTABLE" "$@"
}

# 2. Enter the PicoRV32 Nix shell
echo "Entering Nix shell via nix-portable..."
nixp nix-shell shell.nix --run "
set -euo pipefail

# 3. Download RISC-V sources
echo 'Downloading RISC-V sources...'
make download-tools

# 4. Build all RISC-V toolchains
echo 'Building RISC-V toolchains...'
make build-riscv32imc-tools

echo '✅ RISC-V toolchain setup complete!'
"
