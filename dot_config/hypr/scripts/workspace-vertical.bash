#!/bin/bash
# TODO: this should just output the offset number, hyprctl dispatch should be called in hyprland config

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target-workspace>" >&2
    exit 1
fi

vertical_workspace_offset=10

target=$(($1))
target=$((target * vertical_workspace_offset))

curr_workspace=$(hyprctl monitors -j | jq '.[0].activeWorkspace.id')

workspace_offset=$((target + curr_workspace))

if [ "$workspace_offset" -lt 1 ]; then
    exit 0
fi

if [ "$target" -gt 0 ]; then
    target="+${target}"
fi

hyprctl dispatch workspace "$target"
