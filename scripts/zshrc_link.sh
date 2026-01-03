#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo ""
echo "🔗 Linking .zshrc"

if [ -f "$DOTFILES_DIR/.zshrc" ]; then
  ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  echo "~/.zshrc → $DOTFILES_DIR/.zshrc"
else
  echo "No .zshrc found in repo, skipping"
fi
