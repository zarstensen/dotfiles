-- update search path so it also includes the ~/.config/hypr folder
package.path = package.path .. ";./?.lua;./?/init.lua"

require("monitors")

require("config.plugins.hyprsplit")

require("config.autostart")
require("config.binds")
require("config.env")
require("config.input")
require("config.permissions")
require("config.visuals")

hl.config({
	xwayland = { force_zero_scaling = true },
	misc = { disable_autoreload = true, initial_workspace_tracking = 0 },
})
