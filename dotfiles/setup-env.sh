#!/bin/bash
set -eufo pipefail

# install yay
echo ======== Installing Yay ========
if ! command -v "yay" >/dev/null 2>&1 ; then
    sudo pacman -S --noconfirm --needed git base-devel

    tmp_dir=$(mktemp -d)

    cd $tmp_dir

    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
fi

# install dependencies for conman
echo ======== Installing Conman Dependencies ========

sudo pacman -S --needed --noconfirm python python-yaml python-pydantic python-bracex

echo ======== Post Init Setup Done! ========
