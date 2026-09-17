local dap = require("dap")

-- TODO: maybe third party plugin to do this? idk?
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "codelldb", -- installed with mason
		args = { "--port", "${port}" },
	},
}

local function prompt_args()
	local args = vim.fn.input("Enter args: ")
	return vim.split(args, " ", { trimempty = true })
end

local configs = {
	{
		name = "Debug binary",
		type = "codelldb",
		request = "launch",
		program = require("dap.utils").pick_file,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
	{
		name = "Debug file",
		type = "codelldb",
		request = "launch",
		program = function()
			local file = vim.api.nvim_buf_get_name(0)
			local dir = vim.fs.dirname(vim.fn.fnamemodify(file, ":p"))
			return dir .. "/out/debug/" .. vim.fn.fnamemodify(file, ":t:r")
		end,
		cwd = "${workspaceFolder}",
		preLaunchTask = "g++ Build [debug]",
		stopOnEntry = false,
	},
	{
		name = "Debug make binary",
		type = "codelldb",
		request = "launch",
		program = require("dap.utils").pick_file,
		cwd = "${workspaceFolder}",
		preLaunchTask = "Make Build [debug]",
		stopOnEntry = false,
	},
}

local all_configs = {}
for _, config in ipairs(configs) do
	table.insert(all_configs, config)
	table.insert(all_configs, vim.tbl_extend("force", config, {
		name = config.name .. " (+args)",
		args = prompt_args,
	}))
end

dap.configurations.cpp = all_configs
