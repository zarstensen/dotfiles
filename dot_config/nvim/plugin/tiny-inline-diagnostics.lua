require("utils.lload")("BufEnter", function()
	vim.pack.add({
		"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	})

	require("tiny-inline-diagnostic").setup({
		preset = "powerline",
		options = {
			-- make sure diagnostics are shown *everywhere* not just where the cursor is.
			show_all_diags_on_cursor_line = true,
			show_diags_only_under_cursor = false,
			multilines = { enabled = true, always_show = true },
		},
	})

	vim.diagnostic.config({
		virtual_text = false, -- disable virtual_text virtual_lines handles this for us.
		signs = true,
		underline = true,
	})

	vim.keymap.set({ "n", "" }, "<leader>l", ":TinyInlineDiag toggle<CR>", { desc = "Toggle In[l]ine Diagnostics" })
end)
