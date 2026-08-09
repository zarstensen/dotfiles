require("utils.lload")("BufEnter", function()
	vim.pack.add({
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/andythigpen/nvim-coverage",
	})

	require("coverage").setup()
end)
