#!/bin/bash

# toggle the given workspace.
# if toggling it ON, make sure a window with the given class is present, if not, start some executable on the workspace.

workspace="$1"
class="$2"
exec="$3"
exec="$3"

if [ -z "$workspace" ] || [ -z "$class" ] || [ -z "$exec" ]; then
    echo "Usage: $0 <special_workspace> <required_class> <exec>" >&2
    exit 1
fi

# check if we are currently on the workspace.
# if we are, there is no need to check for any windows, as we simply needs to toggle away from it.

curr_special_workspace=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .specialWorkspace.name')

opened_with_exec=0

if [[ "$curr_special_workspace" != "special:$workspace" ]]; then
    # store boolean result ("true" or "false") in a variable
    result=$(hyprctl clients -j \
        | jq -r --arg w "special:$workspace" --arg c "$class" \
        'map(select(.workspace.name == $w and .class == $c)) | length >= 1')
    
    if [[ "$result" == "false" ]]; then
        hyprctl dispatch exec "[workspace special:$workspace; float; center; size 75% 75%]" "$exec"
        opened_with_exec=1
    fi
fi

if [[ $opened_with_exec == 0 ]]; then
    hyprctl dispatch togglespecialworkspace $workspace
fi
