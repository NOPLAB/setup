#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_dir="$script_dir/nvim"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

usage() {
    printf 'Usage: %s copy [--reverse|-r] | diff\n' "${0##*/}" >&2
}

copy_config() {
    local source_dir=$1 destination_dir=$2 file
    local files=(init.lua lua/config/lazy.lua)
    local plugins=("$source_dir"/lua/plugins/*)

    for file in "${files[@]}"; do
        if [[ ! -f $source_dir/$file ]]; then
            printf 'Missing configuration file: %s\n' "$source_dir/$file" >&2
            return 1
        fi
    done
    if ((${#plugins[@]} == 0)); then
        printf 'No plugin files found in %s\n' "$source_dir/lua/plugins" >&2
        return 1
    fi

    mkdir -p -- "$destination_dir/lua/config" "$destination_dir/lua/plugins"
    for file in "${files[@]}"; do
        cp -- "$source_dir/$file" "$destination_dir/$file"
    done
    for file in "${plugins[@]}"; do
        cp -- "$file" "$destination_dir/lua/plugins/"
    done
}

diff_config() {
    local result=0 status file
    local files=(init.lua lua/config/lazy.lua)

    for file in "${files[@]}"; do
        if diff -u -- "$repo_dir/$file" "$config_dir/$file"; then
            :
        else
            status=$?
            ((status == 1)) || return "$status"
            result=1
        fi
    done
    if diff -ru -- "$repo_dir/lua/plugins" "$config_dir/lua/plugins"; then
        :
    else
        status=$?
        ((status == 1)) || return "$status"
        result=1
    fi
    return "$result"
}

shopt -s nullglob
case ${1:-} in
    copy)
        (($# <= 2)) || { usage; exit 2; }
        case ${2:-} in
            '') copy_config "$repo_dir" "$config_dir" ;;
            -r|--reverse) copy_config "$config_dir" "$repo_dir" ;;
            *) usage; exit 2 ;;
        esac
        ;;
    diff)
        (($# == 1)) || { usage; exit 2; }
        diff_config
        ;;
    *) usage; exit 2 ;;
esac
