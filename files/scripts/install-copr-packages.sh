#!/usr/bin/env bash

set -oue pipefail

# Install COPR packages using the isolated helper function
# This script sources copr-helpers.sh and uses copr_install_isolated()

echo "Installing COPR packages from washkinazy/wayland-wm-extras"
echo "==========================================================="

# Source the COPR helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/copr-helpers.sh"

# Install walker and elephant from washkinazy/wayland-wm-extras COPR
copr_install_isolated washkinazy/wayland-wm-extras walker elephant

echo "COPR packages installed successfully!"
