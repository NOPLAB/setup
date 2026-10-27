#!/usr/bin/env bash
set -euo pipefail

(($# == 0)) || { printf 'Usage: %s\n' "${0##*/}" >&2; exit 2; }
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source_dir="$script_dir/../../config/nvim"
destination_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
files=(init.lua lua/config/lazy.lua)
plugins=()
shopt -s nullglob

for file in "$source_dir"/lua/plugins/*; do
    if [[ -f $file ]]; then
        plugins+=("$file")
    fi
done
for file in "${files[@]}"; do
    if [[ ! -f $source_dir/$file ]]; then
        printf 'Missing configuration file: %s\n' "$source_dir/$file" >&2
        exit 1
    fi
done
if ((${#plugins[@]} == 0)); then
    printf 'No plugin files found in %s\n' "$source_dir/lua/plugins" >&2
    exit 1
fi

mkdir -p -- "$destination_dir/lua/config" "$destination_dir/lua/plugins"
for file in "${files[@]}"; do
    cp -- "$source_dir/$file" "$destination_dir/$file"
done
for file in "${plugins[@]}"; do
    cp -- "$file" "$destination_dir/lua/plugins/"
done
