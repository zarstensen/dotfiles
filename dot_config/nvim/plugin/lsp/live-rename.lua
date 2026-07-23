vim.pack.add({
	"https://github.com/saecki/live-rename.nvim",
})

local lr = require("live-rename")
lr.setup({})

vim.keymap.set({ "n", "x" }, "<leader>nr", lr.map({ cursorpos = 0 }), { desc = "[R]ename Symbol" })
