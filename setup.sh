#!/bin/sh

# Update local
pacman -Syy

# Basic packages
pacman -S git curl wget unzip

# Useful tools
pacman -S vim tmux

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh


