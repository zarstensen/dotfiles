local c = require("config.consts")
local hs = require("plugins.hyprsplit")

hs.config({ num_workspaces = 12, persistent_workspaces = true })

hl.on("monitor.removed", function(_)
    hs.dsp.grab_rogue_windows()
end)

local function swap_all_monitors()
    local monitors = hl.get_monitors()
    table.sort(monitors, function(mon_a, mon_b)
        return hs.MonitorRange:new(mon_a).base < hs.MonitorRange:new(mon_b).base
    end)

    local prev_mon = monitors[#monitors]

    for mon_i = 1, #monitors - 1 do
        local mon = monitors[mon_i]
        hs.dsp.workspace.swap_monitors({ monitor1 = prev_mon.name, monitor2 = mon.name })()
    end
end

hl.bind(c.MAIN_MOD .. " + CTRL + S", swap_all_monitors)

-- Restore workspace state after config reload
hl.on("config.reloaded", function()
    hl.exec_cmd([[
        while IFS=" " read -r name ws; do
            hyprctl dispatch 'hl.dsp.focus({ workspace = '"$ws"' })'
        done < /tmp/hypr-state 2>/dev/null
        focused=$(cat /tmp/hypr-focused 2>/dev/null) && [ -n "$focused" ] &&
            hyprctl dispatch 'hl.dsp.focus({ monitor = "'"$focused"'" })'
    ]])
end)

