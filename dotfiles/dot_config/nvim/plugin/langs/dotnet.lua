vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/GustavEikaas/easy-dotnet.nvim.git",

	-- solution explorer
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/dtrh95/csharp-explorer.nvim",
})

require("easy-dotnet").setup({ picker = "fzf" })
require("csharp-explorer").setup({})
