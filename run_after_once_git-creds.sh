#!/bin/bash
# setup git credentials to work with existing keyring
# this means we dont have to type username / password everytime 
# we clone with https
set -eufo pipefail

sudo pacman --needed --noconfirm -S dotnet-runtime

dotnet tool install -g git-credential-manager
export PATH="$PATH:~/.dotnet/tools"
git-credential-manager configure
