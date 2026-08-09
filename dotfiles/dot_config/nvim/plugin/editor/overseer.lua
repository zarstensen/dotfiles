vim.pack.add({
	"https://github.com/stevearc/overseer.nvim.git",
})

local ovs = require("overseer")
ovs.setup()

vim.keymap.set("n", "<leader>ot", ":OverseerToggle<CR>", { desc = "[T]oggle [O]verseer Window" })
