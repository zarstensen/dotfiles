local c = require("config.consts")

hl.on("hyprland.start", function()
	hl.exec_cmd(c.APPS.NETWORK)
	hl.exec_cmd(c.APPS.WALLPAPER)
	hl.exec_cmd(c.APPS.MENU_INIT)

	for _, applet_cmd in ipairs(c.APPS.APPLETS) do
		hl.exec_cmd(applet_cmd)
	end

	-- auth agent
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	hl.exec_cmd("hyprpm reload -n")

	hl.exec_cmd("elephant")
	hl.exec_cmd("qs -c screen-shell")
end)
