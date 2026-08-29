vim.pack.add({
	"https://codeberg.org/mfussenegger/nvim-dap-python",
})

local dap_py = require("dap-python")

-- use integrated terminal so a random terminal window
-- does not pop up on windows
dap_py.setup("python", { console = "integratedTerminal" })

local dap = require("dap")

-- add configuration to launch file as a module, this assumes the module is relative to cwd
table.insert(dap.configurations.python, {
	type = "python",
	request = "launch",
	name = "module",
	module = function()
		return vim
			.fn
			-- get current file (%) relative to cwd (:.) and strip extension (:r)
			.expand("%:.:r")
			:gsub("/", ".")
	end,
	console = "integratedTerminal",
})

-- allow also stepping in to library code
for _, config in ipairs(dap.configurations.python) do
	config.justMyCode = false
end
