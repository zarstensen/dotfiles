vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/m00qek/baleia.nvim",

	"https://github.com/neogitorg/neogit",
})

-- override process spawn so NVIM_LISTEN_ADDRESS is not set to anything,
-- some other plugins may set this (GhostText) which breaks neogit.
local Process = require("neogit.process")

local orig_spawn = Process.spawn

function Process:spawn(cb)
	self.env = self.env or {}
	self.env.NVIM_LISTEN_ADDRESS = ""
	return orig_spawn(self, cb)
end

vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neo[g]it" })
vim.api.nvim_create_user_command("Git", "Neogit", { nargs = 0 })
