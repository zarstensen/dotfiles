vim.pack.add({
	"https://codeberg.org/mfussenegger/nvim-dap-python",
})

local dap_py = require("dap-python")

-- use integrated terminal so a random terminal window
-- does not pop up on windows
dap_py.setup("python", { console = "integratedTerminal" })

local dap = require("dap")

-- allow also stepping in to library code
for _, config in ipairs(dap.configurations.python) do
	config.justMyCode = false
end
