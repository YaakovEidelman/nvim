#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
    echo "this script is for Arch. see the README for the package list." >&2
    exit 1
fi

want_optional=0
if [ "${1:-}" = "--optional" ]; then
    want_optional=1
fi

pkgs=(
    neovim
    git
    gcc
    make
    cmake
    nodejs
    npm
    ripgrep
    unzip
    tree-sitter-cli
    ttf-jetbrains-mono-nerd
)

if [ "${XDG_SESSION_TYPE:-}" = "x11" ]; then
    pkgs+=(xclip)
else
    pkgs+=(wl-clipboard)
fi

if [ "$want_optional" = 1 ]; then
    pkgs+=(python python-pip dotnet-sdk rustup fd)
fi

sudo pacman -S --needed "${pkgs[@]}"

if [ "$want_optional" = 0 ]; then
    echo
    echo "skipped optional extras (python, python-pip, dotnet-sdk, rustup, fd)."
    echo "re-run with --optional to install them."
fi

nvim_version=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
if [ "$(printf '%s\n0.12\n' "$nvim_version" | sort -V | head -1)" != "0.12" ]; then
    echo
    echo "warning: neovim $nvim_version is too old, this config needs 0.12+."
    echo "install neovim-git from the AUR."
fi

echo
echo "Done. Still to do by hand:"
echo "  - set the Nerd Font in your terminal"
echo "  - start nvim, then run :Lazy restore and the :MasonInstall line from the README"
