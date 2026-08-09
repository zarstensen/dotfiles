#!/bin/bash
set -eufo pipefail

sudo pacman -S --needed --noconfirm python python-yaml python-pydantic python-bracex git >/dev/null 2> >(grep -v 'is up to date -- skipping')

cd "$CHEZMOI_WORKING_TREE"

python -m $1
