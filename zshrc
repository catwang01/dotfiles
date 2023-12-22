# Settings
if [ -f ~/.bashrc ]; then
  source ~/.bashrc 
fi

# Settings
if [ -f ~/.zsh/my_zshrc.zsh ]; then
  source ~/.zsh/my_zshrc.zsh
fi

# Allow private customizations (not checked in to version control)
if [ -f ~/.zsh/my_zshrc_private.zsh ]; then
    source ~/.zsh/my_zshrc_private.zsh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
