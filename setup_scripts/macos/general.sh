#!/bin/bash

# disable press and hold to enter special characters
defaults write -g ApplePressAndHoldEnabled -bool false

# make key repeat faster
defaults write -g KeyRepeat -int 2