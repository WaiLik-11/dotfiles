#!/usr/bin/env bash

echo ""
echo "Node.js setup"

export NVM_DIR="$HOME/.nvm"

if [[ "$OS" == "macos" ]]; then
  source "/opt/homebrew/opt/nvm/nvm.sh"
else
  source "$NVM_DIR/nvm.sh"
fi

if ! command_exists node; then
  nvm install --lts
fi

nvm alias default lts/*
node -v
npm -v
