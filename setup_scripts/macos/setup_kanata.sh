#!/bin/bash
this_dir=$(dirname -- "$( readlink -f -- "$0"; )")

cd "$this_dir/../../general-keybindings/kanata"
python3 register.py