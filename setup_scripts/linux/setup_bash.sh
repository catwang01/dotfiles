#!/bin/bash

if [ ! -L ~/.bashrc ]; 
then
    if [ ! -d ~/.bash ]; then
        mkdir ~/.bash
    fi
    cat ~/.bashrc >> ~/.bash/my_bashrc_private
    mv ~/.bashrc ~/.bashrc.back
fi