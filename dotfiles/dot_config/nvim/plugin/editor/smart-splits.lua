vim.pack.add({
	"https://github.com/mrjones2014/smart-splits.nvim",
})

local ssp =require('smart-splits')
ssp.setup({ default_amount = 2})

vim.keymap.set('n', "<M-h>", ssp.resize_left)
vim.keymap.set('n', "<M-j>", ssp.resize_down)
vim.keymap.set('n', "<M-k>", ssp.resize_up)
vim.keymap.set('n', "<M-l>", ssp.resize_right)
