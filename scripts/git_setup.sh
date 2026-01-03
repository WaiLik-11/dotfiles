#!/usr/bin/env bash

echo ""
echo "Git setup"

read -r -p "Git user.name (Enter to skip): " GIT_NAME
read -r -p "Git user.email (Enter to skip): " GIT_EMAIL

[ -n "$GIT_NAME" ] && git config --global user.name "$GIT_NAME"
[ -n "$GIT_EMAIL" ] && git config --global user.email "$GIT_EMAIL"

git config --global init.defaultBranch main

KEY="$HOME/.ssh/id_ed25519"

if [ ! -f "$KEY" ]; then
  ssh-keygen -t ed25519 -C "${GIT_EMAIL:-$USER@$(hostname)}" -f "$KEY" -N ""
fi

echo ""
echo "👉 Add this SSH key to GitHub:"
echo "--------------------------------"
cat "$KEY.pub"
echo "--------------------------------"
echo "https://github.com/settings/ssh/new"

read -r -p "Press Y after adding key to continue with installation (N to abort): " yn
[[ "$yn" =~ ^[Yy]$ ]] || exit 1
