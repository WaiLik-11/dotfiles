#!/usr/bin/env bash

echo ""
echo "🔧 Installing base tools..."

if [[ "$OS" == "macos" ]]; then
  brew install git curl zsh nvm || true
else
  sudo apt-get install -y git curl zsh ca-certificates
fi
