require("utils.lload")("WinEnter", function()
	vim.pack.add({
		"https://github.com/igorlfs/nvim-dap-view",
	})

	-- TODO: how to have multiple windows?
	require("dap-view").setup({
		winbar = {
			sections = { "watches", "scopes", "console", "exceptions", "breakpoints", "threads", "repl" },
			-- Must be one of the sections declared above
			default_section = "scopes",
			-- controls = { enabled = true },
		},
		windows = { size = 0.20, position = "left" },
		-- virtual_text = { enabled = true },
	})

	local dap = require("dap")

	dap.listeners.after.event_initialized["dapui_config"] = function()
		vim.cmd(":DapViewOpen")
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		vim.cmd(":DapViewClose")
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		vim.cmd(":DapViewClose")
	end
end)
