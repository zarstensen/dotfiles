#!/usr/bin/bash
original_pos="$(hyprctl cursorpos | tr ',' ' ')" &&
hyprctl dispatch movecursor 99999 99999
hyprpicker -rz &
hyprctl dispatch movecursor $original_pos
screenshot="$(mktemp).png"

# Use slurp to select a region and grim to directly capture that region
# This handles scaling correctly as grim receives the scaled coordinates from slurp
if region=$(slurp -b 0B0F18CC); then
    sleep 0.2
    grim -g "$region" "$screenshot"
    wl-copy < "$screenshot"
    size=$(wc -c < "$screenshot")
    if [ "$size" -gt 0 ]; then
        notify-send -i "$screenshot" "📸 Screenshot copied to clipboard"
    fi
fi

sleep 0.1
pkill hyprpicker
rm -f "$screenshot"
