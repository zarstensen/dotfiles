require("utils.lload")("BufEnter", function()
	vim.pack.add({
		"https://github.com/stevearc/conform.nvim",
	})

	require("conform").setup({
		notify_on_error = false,
		autosave = false,
		formatters_by_ft = {
			lua = { "stylua" },
			gdshader = { "clang-format" },
		},
	})

	vim.keymap.set({ "n", "" }, "<leader>f", function()
		require("conform").format({ async = true, lsp_format = "fallback" }, function(_)
			vim.cmd("write")
		end)
	end, { desc = "[F]ormat Buffer" })

	vim.keymap.set({ "n", "" }, "<C-S>", function()
		-- require("conform").format({ async = true, lsp_format = "fallback" }, function(_)
		vim.cmd("write")
		-- end)
	end, { desc = "Write file contents to disc" })
end)
