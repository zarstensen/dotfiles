#!/bin/bash
set -eufo pipefail

sudo pacman --noconfirm --needed -S rustup
rustup default stable
yay --noconfirm --needed -S rustdesk
