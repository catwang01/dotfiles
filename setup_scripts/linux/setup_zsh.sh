#!/bin/bash

install_zsh()
{
    sudo apt-get install zsh
}

if [ `cat /etc/shells | grep zsh | wc -l` -eq 0 ]; 
then
    echo 'zsh is not installed. Installing zsh...'
    install_zsh
else
    echo 'zsh is installed. Skipping zsh installation...'
fi