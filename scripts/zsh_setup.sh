#!/usr/bin/env bash

echo ""
if prompt_yesno "Install Oh My Zsh?" true; then
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
else
  echo "Skipping Oh My Zsh..."
fi
