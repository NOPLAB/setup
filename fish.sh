#!/usr/bin/env bash
set -euo pipefail

command -v curl >/dev/null || { printf 'curl is required.\n' >&2; exit 1; }
command -v fish >/dev/null || { printf 'fish is required.\n' >&2; exit 1; }

curl -fsSL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fish -c 'omf install https://github.com/jhillyerd/plugin-git'
