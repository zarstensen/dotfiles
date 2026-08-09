vim.pack.add({
	"https://github.com/shortcuts/no-neck-pain.nvim",
})

require("no-neck-pain").setup({
	buffers = { right = { enabled = false } },
	integrations = {
		NeoTree = { position = "right" },
	},
})

vim.keymap.set({ "n", "v", "x" }, "<C-W>c", ":NoNeckPain<CR>")
