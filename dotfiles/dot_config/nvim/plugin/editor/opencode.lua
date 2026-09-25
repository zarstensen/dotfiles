vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",

	{ src = "https://github.com/sudo-tee/opencode.nvim", version = "v2" },
})

require("utils.lload")("FileType", function()
	vim.pack.add({
		"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	})

	require("render-markdown").setup({
		anti_conceal = { enabled = false },
		file_types = { "markdown", "opencode_output" },
	})
end, { "markdown", "Avante", "copilot-chat", "opencode_output" })

require("opencode").setup({
	keymap_prefix = "<leader>h",
	ui = { questions = { use_vim_ui_select = true } },
})
