#!/usr/bin/env bash
# install.sh - One-shot installer for Wai Lik's dotfiles
# Usage:
#   ./install.sh
# Or non-interactive:
#   GIT_NAME="Alice" GIT_EMAIL="alice@example.com" ./install.sh
set -euo pipefail

DOTFILES_DIR="$(pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo ""
echo "=============================="
echo "  Wai Lik dotfiles installer"
echo "  Directory: $DOTFILES_DIR"
echo "=============================="
echo ""

# --- Helpers ---
is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_debian_like() {
  [ -f /etc/os-release ] && grep -qiE 'debian|ubuntu|linuxmint' /etc/os-release
}

command_exists() { command -v "$1" >/dev/null 2>&1; }

prompt_yesno() {
  # prompt_yesno "Question?" default_yes(true/false)
  local __q="$1"; local __def="${2:-true}"
  local __resp
  if [ "$__def" = true ]; then
    read -r -p "$__q [Y/n]: " __resp
    __resp="${__resp:-Y}"
  else
    read -r -p "$__q [y/N]: " __resp
    __resp="${__resp:-N}"
  fi
  [[ "$__resp" =~ ^[Yy] ]]
}

# --- 1) Install base packages ---
echo "🔎 Checking required packages: git, curl, zsh"
if is_macos; then
  if ! command_exists brew; then
    echo "🍺 Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  echo "🔁 brew update && install packages..."
  brew update
  brew install git curl zsh || true
elif is_debian_like; then
  echo "🔁 Updating apt (requires sudo) and installing packages..."
  sudo apt-get update -y
  sudo apt-get install -y git curl ca-certificates zsh || true
else
  echo "⚠️ Unsupported OS detected. Make sure zsh, git and curl are installed manually."
fi

# --- 2) Install Oh My Zsh non-interactively ---
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "✅ Oh My Zsh already installed."
else
  echo "📥 Installing Oh My Zsh (non-interactive)..."
  # RUNZSH=no CHSH=no KEEP_ZSHRC=yes to avoid interactive changes
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "✅ Oh My Zsh installed."
fi

# --- 3) Install recommended plugins (optional clones) ---
install_plugin_if_missing() {
  local repo="$1" path="$2"
  if [ ! -d "$path" ]; then
    echo "⬇️ Installing $repo -> $path"
    git clone --depth=1 "$repo" "$path" || true
  else
    echo "✅ Plugin already installed: $path"
  fi
}

if prompt_yesno "Install zsh-autosuggestions and zsh-syntax-highlighting plugins?" true; then
  install_plugin_if_missing "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  install_plugin_if_missing "https://github.com/zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# --- 4) Symlink dotfiles (idempotent) ---
echo "🔗 Creating symlinks (will overwrite existing dotfiles with symlink)..."
# Add any future symlinks here
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
echo "  - $HOME/.zshrc -> $DOTFILES_DIR/.zshrc"
echo "✅ Symlinks created."

# --- 5) Git config prompt (name/email) ---
# Allow non-interactive env overrides
if [ -n "${GIT_NAME-}" ] 2>/dev/null || [ -n "${GIT_EMAIL-}" ] 2>/dev/null; then
  GIT_NAME_INPUT="${GIT_NAME:-}"
  GIT_EMAIL_INPUT="${GIT_EMAIL:-}"
else
  echo ""
  echo "✍️  Git identity"
  read -r -p "  Git user.name (press Enter to skip): " GIT_NAME_INPUT
  read -r -p "  Git user.email (press Enter to skip): " GIT_EMAIL_INPUT
fi

echo "🔧 Applying git configuration..."
if [ -n "$GIT_NAME_INPUT" ]; then
  git config --global user.name "$GIT_NAME_INPUT"
  echo "  - user.name = $GIT_NAME_INPUT"
fi
if [ -n "$GIT_EMAIL_INPUT" ]; then
  git config --global user.email "$GIT_EMAIL_INPUT"
  echo "  - user.email = $GIT_EMAIL_INPUT"
fi

git config --global init.defaultBranch main
git config --global color.ui auto
git config --global core.editor "code --wait" 2>/dev/null || true
git config --global credential.helper cache 2>/dev/null || true
echo "✅ Git config applied."

# --- 6) SSH key generation for GitHub (optional) ---
echo ""
if prompt_yesno "Do you want to create / ensure an SSH key for GitHub?" true; then
  KEY_PATH="${SSH_KEY_PATH:-$HOME/.ssh/id_ed25519}"
  if [ -f "$KEY_PATH" ]; then
    echo "✅ SSH key already exists at $KEY_PATH"
  else
    echo "🛠 Generating ed25519 SSH key at $KEY_PATH"
    # Use provided email for comment, or fallback to hostname
    SSH_COMMENT="${GIT_EMAIL_INPUT:-$USER@$(hostname)}"
    mkdir -p "$(dirname "$KEY_PATH")"
    ssh-keygen -t ed25519 -C "$SSH_COMMENT" -f "$KEY_PATH" -N ""
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add "$KEY_PATH" >/dev/null
    echo ""
    echo "⬇️ Your public key (copy to GitHub):"
    echo "----------------------------------------"
    cat "${KEY_PATH}.pub"
    echo "----------------------------------------"
    echo ""
    # Offer to open GitHub key page
    if command_exists xdg-open || command_exists open; then
      if prompt_yesno "Open GitHub SSH keys page in your browser to paste the key?" true; then
        if command_exists xdg-open; then
          xdg-open "https://github.com/settings/ssh/new" >/dev/null 2>&1 || true
        elif command_exists open; then
          open "https://github.com/settings/ssh/new" >/dev/null 2>&1 || true
        fi
      else
        echo "🔗 Add the public key manually at: https://github.com/settings/ssh/new"
      fi
    else
      echo "🔗 Add the public key manually at: https://github.com/settings/ssh/new"
    fi
  fi
fi

# --- 7) Make zsh the default shell (best-effort) ---
echo ""
NEW_SHELL="$(command -v zsh || true)"
if [ -n "$NEW_SHELL" ] && [ "$SHELL" != "$NEW_SHELL" ]; then
  echo "🔁 Changing default shell to $NEW_SHELL (may ask for password)"
  if chsh -s "$NEW_SHELL" "$USER" 2>/dev/null; then
    echo "✅ Default shell changed. You may need to log out and back in for it to take effect."
  else
    echo "⚠️ Could not change shell automatically. If you want to change manually, run:"
    echo "    chsh -s $NEW_SHELL"
  fi
else
  echo "✅ zsh already default shell or not found."
fi

# --- 8) Final message ---
echo ""
echo "🎉 All done! Recommended next steps:"
echo "  - Open a new terminal window or run: source ~/.zshrc"
echo "  - If you created an SSH key, add it to GitHub: https://github.com/settings/ssh/new"
echo ""
echo "If you want to run non-interactively in CI or a script, you can:"
echo "  GIT_NAME='Your Name' GIT_EMAIL='you@example.com' SSH_KEY_PATH=~/.ssh/id_ed25519 ./install.sh"
echo ""
echo "Happy hacking — enjoy your new environment! 🚀"
