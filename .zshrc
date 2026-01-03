# ---------- Detect OS ----------
OS="$(uname -s)"
IS_MAC=false
IS_LINUX=false

if [[ "$OS" == "Darwin" ]]; then
  IS_MAC=true
else
  IS_LINUX=true
fi

# ---------- Oh My Zsh ----------
export ZSH="$HOME/.oh-my-zsh"

if [ -d "$ZSH" ]; then
  # Theme selection
  if $IS_LINUX; then
    ZSH_THEME="awesomepanda"
  else
    ZSH_THEME="robbyrussell" # macOS default
  fi

  plugins=(git)

  # Optional plugins
  [[ -f "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
    && plugins+=(zsh-autosuggestions)

  [[ -f "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
    && plugins+=(zsh-syntax-highlighting)

  source "$ZSH/oh-my-zsh.sh"
else
  echo "⚠️ Oh My Zsh not installed — using plain zsh"
fi

# ---------- NVM ----------
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# ---------- User aliases ----------
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
