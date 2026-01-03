#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DIR/scripts/utils.sh"
source "$DIR/scripts/detect_os.sh"

require_macos_linux

source "$DIR/scripts/base_tools.sh"
source "$DIR/scripts/git_setup.sh"
source "$DIR/scripts/zsh_setup.sh"
source "$DIR/scripts/zshrc_link.sh"
source "$DIR/scripts/node_setup.sh"

echo ""
echo "All setup complete!"
echo "Please restart your terminal & VS Code"