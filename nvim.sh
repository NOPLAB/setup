#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_DIR=$HOME/.config

function copy2nvim {
    mkdir -p $HOME/.config/nvim
    mkdir -p $HOME/.config/nvim/lua/plugins
    mkdir -p $HOME/.config/nvim/lua/config

    cp $SCRIPT_DIR/nvim/init.lua $HOME/.config/nvim/init.lua
    cp $SCRIPT_DIR/nvim/lua/plugins/init.lua $HOME/.config/nvim/lua/plugins/init.lua
    cp $SCRIPT_DIR/nvim/lua/config/lazy.lua $HOME/.config/nvim/lua/config/lazy.lua
}

function copy2git {
    cp $HOME/.config/nvim/init.lua $SCRIPT_DIR/nvim/init.lua
    cp $HOME/.config/nvim/lua/plugins/init.lua $SCRIPT_DIR/nvim/lua/plugins/init.lua
    cp $HOME/.config/nvim/lua/config/lazy.lua $SCRIPT_DIR/nvim/lua/config/lazy.lua
}

function config_diff {
    echo NEOVIM_CONFIG_DIR is $HOME
    echo 
    echo Diff: $CONFIG_DIR/nvim/init.lua
    diff $CONFIG_DIR/nvim/init.lua $SCRIPT_DIR/nvim/init.lua
    echo 
    echo Diff: $CONFIG_DIR/nvim/lua/plugins/init.lua
    diff $CONFIG_DIR/nvim/lua/plugins/init.lua $SCRIPT_DIR/nvim/lua/plugins/init.lua
}


if [[ $1 == "copy" ]]; then
    if [[ $2 == "r" || $2 == "rev" || $2 == "reverse" ]]; then
	copy2git
    else
	copy2nvim
    fi
fi

if [[ $1 == "diff" ]]; then
    config_diff
fi

