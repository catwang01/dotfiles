#!/bin/bash

if [ -e ~/.bashrc ]; 
then
    if [ ! -d ~/.bash ]; then
        mkdir ~/.bash
    fi
    cat ~/.bashrc >> ~/.bash/my_bashrc_private
    mv ~/.bashrc ~/.bashrc.back
else
    echo 'bashrc is not a symbol link'
fi