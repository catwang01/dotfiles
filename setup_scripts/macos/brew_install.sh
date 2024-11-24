#!/bin/bash

# parse 3 arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <program_name> [<use_case>]"
    exit 1
fi

program_name=$1
use_case=${2:-0}

brew list "$program_name"

if [ "$?" -eq 0 ]; then
    echo "$program_name is already installed."
    exit 0
  else
    echo "$program_name is not installed, installing it..."
    if [ "$use_case" == "0" ]; then
        brew install "$program_name"
    elif [ "$use_case" == "1" ]; then
        brew install --cask "$program_name"
    else
        echo "Invalid use case: $use_case"
        exit 1
    fi
fi