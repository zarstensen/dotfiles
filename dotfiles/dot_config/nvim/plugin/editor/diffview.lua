vim.pack.add({
	"https://github.com/sindrets/diffview.nvim.git",
})

local dv_keymaps = {
	{ "n", "<leader>ds", ":DiffviewClose<CR>", { desc = "Close [D]iff View" } },
	{ "n", "<leader>e", ":DiffviewToggleFiles<CR>", { desc = "Toggle Diff View File [E]xplorer" } },
}

require("diffview").setup({
	keymaps = {
		view = dv_keymaps,
		file_panel = dv_keymaps,
		file_history_panel = dv_keymaps,
	},
})

vim.keymap.set("n", "<leader>ds", ":DiffviewOpen<CR>", { desc = "[S]how [D]iff View" })
vim.keymap.set("n", "<leader>dr", ":DiffviewRefresh<CR>", { desc = "[R]efresh [D]iff View" })
vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory<CR>", { desc = "Show [D]iff View [H]istory" })
vim.keymap.set("n", "<leader>dH", ":DiffviewFileHistory %<CR>", { desc = "Show [D]iff View Current File [H]istory" })
