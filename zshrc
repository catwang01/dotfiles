# Settings
if [ ~/.zsh/my_zshrc.zsh ]; then
  source ~/.zsh/my_zshrc.zsh
fi

# Allow private customizations (not checked in to version control)
if [ -f ~/.zsh/my_zshrc_local.zsh ]; then
    source ~/.zsh/my_zshrc_local.zsh
fi
