#!/bin/bash
set -eufo pipefail

echo ======== Installing Icon Pack ========

tmp_dir=$(mktemp -d)

cd $tmp_dir

git clone https://github.com/igorfmoraes/Mignon-icon-theme.git

cd Mignon-icon-theme

echo n | ./install.sh -a

cd ..

# this is used by the quickshell bar
git clone https://github.com/vinceliuice/Fluent-icon-theme

cd Fluent-icon-theme

echo n | ./install.sh

# set icon themes for GTK aps
gsettings set org.gnome.desktop.interface icon-theme 'Mignon-pastel'

# set color theme for GTK aps
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"

echo ======== Finished Theming Setup ========
