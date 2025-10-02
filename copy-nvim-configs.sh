#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/nvim/lua/plugins
mkdir -p $HOME/.config/nvim/lua/config

cp $SCRIPT_DIR/nvim/init.lua $HOME/.config/nvim/init.lua
cp $SCRIPT_DIR/nvim/lua/plugins/init.lua $HOME/.config/nvim/lua/plugins/init.lua
cp $SCRIPT_DIR/nvim/lua/config/lazy.lua $HOME/.config/nvim/lua/config/lazy.lua
