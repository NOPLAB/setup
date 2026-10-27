#!/usr/bin/env bash
set -euo pipefail

# Run as the target user so uv is installed in the right home directory.
if [ "$(id -u)" -eq 0 ]; then
    printf 'Run this script as a regular user with sudo access.\n' >&2
    exit 1
fi

os_release_file=${OS_RELEASE_FILE:-/etc/os-release}
if [ ! -r "$os_release_file" ]; then
    printf 'Cannot read OS information: %s\n' "$os_release_file" >&2
    exit 1
fi
# shellcheck disable=SC1090
. "$os_release_file"

case ${ID:-} in
    arch) package_manager=pacman ;;
    fedora) package_manager=dnf ;;
    ubuntu) package_manager=apt-get ;;
    *)
        printf 'Unsupported distribution: %s (supported: Arch Linux, Fedora, Ubuntu).\n' "${ID:-unknown}" >&2
        exit 1
        ;;
esac

if ! command -v "$package_manager" >/dev/null 2>&1; then
    printf 'Package manager not found: %s\n' "$package_manager" >&2
    exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
    printf 'sudo is required to install system packages.\n' >&2
    exit 1
fi
case $package_manager in
    pacman)
        sudo pacman -Syu --needed git curl wget unzip vim tmux fish neovim
        ;;
    dnf)
        sudo dnf upgrade
        sudo dnf install git curl wget unzip vim-enhanced tmux fish neovim
        ;;
    apt-get)
        sudo apt-get update
        sudo apt-get upgrade
        sudo apt-get install git curl wget unzip vim tmux fish neovim
        ;;
esac

if ! command -v uv >/dev/null 2>&1; then
    installer=$(mktemp)
    trap 'rm -f "$installer"' EXIT HUP INT TERM
    curl -fsSL https://astral.sh/uv/install.sh -o "$installer"
    bash "$installer"
    rm -f "$installer"
    trap - EXIT HUP INT TERM
fi
