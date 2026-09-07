vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/GustavEikaas/easy-dotnet.nvim.git",
})

require("easy-dotnet").setup({ picker = "fzf" })
