#!/usr/bin/env bash
set -e

# ==============================
# macOS bootstrap for dotfiles
# ==============================

# Check if user is on macOs
if [["$(uname -s)" != "Darwin"]]; then
    echo "Unsupported OS."
    echo ""
    echo "This script only supports macOs."
    echo ""
    echo "Detected OS: $(uname -s)"
    echo ""
    echo "If you are on Linux / WSL, please run:"
    echo "  ./install.sh"
    exit 1
fi

echo "macOs detected - Starting bootstrap..."

# 1. Install Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install || true
    echo ""
    echo "macOs popup shown."
    echo "Complete the Xcode installation, then re-run this script."
    exit 0
fi

# 2. Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is in PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. Git
if ! command -v git >/dev/null 2>&1; then
    echo "Installing Git..."
    brew install git
fi

# 4. Clone dotfiles repository
DOTFILES_DIR="$HOME/.dotfiles"

if [ ! -d "DOTFILES_DIR" ]; then
    echo "Cloneing dotfiles repository by WaiLik"
    git clone https://github.com/WaiLik-11/dotfiles.git "$DOTFILES_DIR"
else
    echo "Dotfiles repository already exists at $DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# 5. Run the main installer 
echo "---->>>> Running install.sh"
./install.sh