vim.pack.add({
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	-- optional, but recommended
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/antosha417/nvim-lsp-file-operations",
})

require("neo-tree").setup({
	auto_clean_after_session_restore = true,
	close_if_last_window = true,
	group_empty_dirs = true,

	window = {
		position = "right",
	},
	filesystem = {
		-- do not auto open neo-tree when starting neovim
		hijack_netrw_behavior = "disabled",
		filtered_items = {
			hide_by_pattern = {
				"*.uid",
				"*~",
			},
		},
	},
})

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Open [E]xplorer" })
vim.keymap.set("n", "<leader>ge", ":Neotree git_status toggle<CR>", { desc = "Open [G]it Status [E]xplorer" })
