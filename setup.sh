#!/bin/bash

echo "🚀 Starting full environment setup..."

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📥 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Run symlink and git setup
bash ~/dotfiles/setup_symlinks.sh
bash ~/dotfiles/setup_git.sh

echo "🎉 Setup complete! Reload terminal or run: source ~/.zshrc"
