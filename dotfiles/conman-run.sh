#!/bin/bash
set -eufo pipefail

if command -v grep >/dev/null 2>&1; then
    sudo pacman -S grep
fi

sudo pacman -S --needed --noconfirm python python-yaml python-pydantic python-bracex git >/dev/null 2> >(grep --line-buffered -v 'is up to date -- skipping')

cd "$CHEZMOI_WORKING_TREE"

python -m $1
