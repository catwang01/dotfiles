#!/bin/bash

show_usage() {
    echo "Usage: $0 <program_name> [<use_cask>]"
    echo "program_name: the name of the program to install"
    echo "use_cask: 0 for brew install, 1 for brew install --cask"
}

# parse 3 arguments
if [ "$#" -ne 2 ]; then
    show_usage
    exit 1
fi

program_name=$1
use_cask=${2:-0}

brew list "$program_name"

if [ "$?" -eq 0 ]; then
    echo "$program_name is already installed."
    exit 0
  else
    echo "$program_name is not installed, installing it..."
    if [ "$use_cask" == "0" ]; then
        brew install "$program_name"
    elif [ "$use_cask" == "1" ]; then
        brew install --cask "$program_name"
    else
        echo "Invalid use cask: $use_cask"
        exit 1
    fi
fi