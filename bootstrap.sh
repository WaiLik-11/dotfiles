#!/usr/bin/env bash

# ==============================
# WaiLik's bootstrap for dotfiles
# ==============================

set -e
echo "Starting bootstrap process..."

OS="$(uname -s)"

install_macos() {
    echo "macOs detected. Running macOs bootstrap..."

    if ! command -v brew >/dev/null 2>&1; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install git curl
}

install_linux() {
    echo "Linux detected. Running Linux bootstrap..."
    sudo apt-get update -y
    sudo apt-get install -y git curl ca-certificates
}

case "$OS" in
  Darwin) install_macos ;;
  Linux)  install_linux ;;
  *)
    echo "❌ Unsupported OS"
    exit 1
    ;;
esac

echo "✅ git installed: $(git --version)"

REPO_URL="https://github.com/WaiLik-11/dotfiles.git"
TARGET="$HOME/dotfiles"

if [ -d "$TARGET" ]; then
  echo "dotfiles already exists at $TARGET"
else
  git clone "$REPO_URL" "$TARGET"
fi

cd "$TARGET"
chmod +x install.sh

echo "Handing over to install.sh..."
./install.sh