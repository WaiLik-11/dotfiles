export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="awesomepanda"
plugins=(git)

# optional plugins: only load if installed
if [ -f "${ZSH}/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  plugins+=(zsh-autosuggestions)
fi

if [ -f "${ZSH}/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  plugins+=(zsh-syntax-highlighting)
fi

# source oh-my-zsh
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# user custom aliases
if [ -f "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi
