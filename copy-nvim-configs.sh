#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

cp $SCRIPT_DIR/nvim/init.lua $HOME/.config/nvim/init.lua
cp $SCRIPT_DIR/nvim/lua/plugins/init.lua $HOME/.config/nvim/lua/plugins/init.lua
