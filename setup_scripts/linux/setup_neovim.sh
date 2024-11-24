#!/bin/bash

install_neovim() {
  echo "neovim is not installed! Downloading neovim"
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  if [ "$?" -ne 0 ]; then
    echo "Failed to download neovim!"
    return 1
  fi
  chmod u+x nvim.appimage
  
  echo "Move neovim into /usr/local/bin"
  sudo mv ./nvim.appimage /usr/local/bin/nvim
  return 0
}

nvim -v
if [ "$?" -eq 0 ]; then
  echo "neovim is installed!"
else
  echo "neovim is not installed, installing neovim..."
  install_neovim
fi