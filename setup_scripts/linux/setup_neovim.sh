#!/bin/bash

install_neovim() {
  echo "neovim is not installed! Downloading neovim"
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  
  echo "Move neovim into /usr/bin"
  sudo mv ./nvim.appimage /usr/bin/nvim
  return 0
}

nvim -v
if [ $? -eq 0 ]; then
  echo "neovim is installed!"
else
  echo "neovim is not installed, installing neovim..."
  install_neovim
fi