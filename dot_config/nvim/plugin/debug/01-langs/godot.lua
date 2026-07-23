local dap = require("dap")

dap.adapters.godot = {
	type = "server",
	host = "127.0.0.1",
	-- same port which the godot editor is set up to.
	port = 6006,
}

dap.configurations.gdscript = {
	{
		type = "godot",
		request = "launch",
		name = "Launch Current Scene",
		project = "${workspaceFolder}",
		scene = "current",
	},
	{
		type = "godot",
		request = "launch",
		name = "Launch Main Scene",
		project = "${workspaceFolder}",
		scene = "main",
	},
	{
		type = "godot",
		request = "launch",
		name = "Launch Pinned Scene",
		project = "${workspaceFolder}",
		scene = "pinned",
	},
	{
		type = "godot",
		request = "attach",
		name = "Attach to Running Scene",
		project = "${workspaceFolder}",
	},
}
