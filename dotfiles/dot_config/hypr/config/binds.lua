local c = require("config.consts")
local hs = require("plugins.hyprsplit")
local mainMod = c.MAIN_MOD

-- General binds
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprquickframe"))
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(c.APPS.TERMINAL))
hl.bind(mainMod .. " + BACKSPACE", hl.dsp.window.close())
hl.bind(mainMod .. " + CTRL + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(c.APPS.FILE_MANAGER))
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(c.APPS.MENU_OPEN))
hl.bind(mainMod .. " + P", hl.dsp.layout("pseudo"))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Focus movement
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Lid switch
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("hyprlock"), { locked = true })

-- Workspace switching (custom key -> workspace number mapping)
local workspace_keys = {
    "A", "Q", "1", "S", "W", "2",
    "D", "E", "3", "F", "R", "4",
}

for i, key in ipairs(workspace_keys) do
    hl.bind(mainMod .. " + " .. key, hs.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = true }))
end

-- Special workspaces
local special_apps = {
    { key = "1", cmd = "bash " .. c.DIRS.SCIPTS .. "/special-app.bash term kitty kitty" },
    { key = "2", cmd = "bash " .. c.DIRS.SCIPTS .. "/special-app.bash music Spotify spotify-launcher" },
    { key = "3", cmd = "bash " .. c.DIRS.SCIPTS .. "/special-app.bash browser firefox 'firefox --new-window'" },
    { key = "4", cmd = "bash " .. c.DIRS.SCIPTS .. "/special-app.bash files org.kde.dolphin dolphin" },
    { key = "5", cmd = "bash " .. c.DIRS.SCIPTS .. "/special-app.bash comms discord discord" },
}

for _, binding in ipairs(special_apps) do
    hl.bind(mainMod .. " + CTRL + " .. binding.key, hl.dsp.exec_cmd(binding.cmd))
end

for i = 6, 9 do
    hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.workspace.toggle_special(tostring(i)))
end
hl.bind(mainMod .. " + CTRL + 0", hl.dsp.workspace.toggle_special("0"))

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + x", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + z", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Save workspace state and reload config
hl.bind(mainMod .. " + SHIFT + N", function()
    hl.exec_cmd([[
        hyprctl monitors -j | jq -r '.[] | "\(.name) \(.activeWorkspace.id)"' > /tmp/hypr-state &&
        hyprctl monitors -j | jq -r '(.[] | select(.focused) | .name)' > /tmp/hypr-focused &&
        hyprctl reload
    ]])
end)
