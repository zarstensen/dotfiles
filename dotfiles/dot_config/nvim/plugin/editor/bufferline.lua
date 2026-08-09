vim.pack.add({
	"https://github.com/akinsho/bufferline.nvim",
	-- dependencies
	"https://github.com/nvim-tree/nvim-web-devicons",
})

require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp",
		separator_style = "thin",
		pick = {
			-- only lowercase or numbers should be allowed
			alphabet = "abcdefghijklmopqrstuvwxyz1234567890",
		},
	},
})

vim.keymap.set("n", "<Leader>ix", function()
	require("snacks").bufdelete.delete()
end, { desc = "Close visible buffer" })
vim.keymap.set("n", "<Leader>idD", function()
	require("snacks").bufdelete.all()
end, { desc = "Close all visible buffers" })
vim.keymap.set("n", "<Leader>idd", ":BufferLineCloseOthers<CR>", { desc = "Close all other visible buffers" })
vim.keymap.set("n", "<Leader>idl", ":BufferLineCloseRight<CR>", { desc = "Close all visible buffers to the right" })
vim.keymap.set("n", "<Leader>idh", ":BufferLineCloseLeft<CR>", { desc = "Close all visible buffers to the left" })
vim.keymap.set("n", "<Leader>iP", ":BufferLineTogglePin<CR>", { desc = "Pin current buffer" })
vim.keymap.set("n", "<Leader>ip", ":BufferLinePick<CR>", { desc = "Pick buffer" })

vim.keymap.set("n", "<Leader>ih", ":BufferLineCyclePrev<CR>", { desc = "Move to left buffer" })
vim.keymap.set("n", "<Leader>il", ":BufferLineCycleNext<CR>", { desc = "Move to right buffer" })

vim.keymap.set("n", "<Leader>ij", ":BufferLineMovePrev<CR>", { desc = "Move buffer to the left" })
vim.keymap.set("n", "<Leader>ik", ":BufferLineMoveNext<CR>", { desc = "Move buffer to the right" })

local quick_access_buffers = {
	[1] = "q",
	[2] = "w",
	[3] = "e",
	[4] = "r",
	[5] = "t",
	[6] = "y",
	[7] = "u",
	[8] = "i",
	[9] = "o",
}

for buff, key in pairs(quick_access_buffers) do
	vim.keymap.set(
		"n",
		string.format("<Leader>i%s", key),
		string.format(":BufferLineGoToBuffer %d<CR>", buff),
		{ desc = string.format("Go to buffer %d", buff) }
	)
end
