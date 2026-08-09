require("utils.lload")("BufEnter", function()
	vim.pack.add({
		"https://github.com/mfussenegger/nvim-dap",
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/theHamsta/nvim-dap-virtual-text",
	})

	require("nvim-dap-virtual-text").setup({
		highlight_new_as_changed = true,
		only_first_definition = false,
		-- virt_text_pos = "eol",
	})
end)
