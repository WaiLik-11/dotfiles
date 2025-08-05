#!/bin/bash

echo "🔧 Setting up Git config..."

git config --global user.name "Wai Lik"
git config --global user.email "wailik1804@gmail.com"
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global core.editor "code --wait"
git config --global credential.helper cache

echo "✅ Git config done."

# SSH Key for GitHub
echo "🔐 Checking SSH key..."
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "wailik1804@gmail.com" -f ~/.ssh/id_ed25519 -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo "⬇️ Public key:"
    cat ~/.ssh/id_ed25519.pub
    echo "📋 Copy the above key and add it to your GitHub SSH keys:"
    echo "🔗 https://github.com/settings/ssh/new"
else
    echo "✅ SSH key already exists."
fi
