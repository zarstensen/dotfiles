vim.schedule(function()
	vim.o.clipboard = ""
end)

vim.keymap.set("n", "<leader>cos", ':call setreg("@", getreg("+"))<CR>', { desc = "Sync clipboard os => nvim" })
vim.keymap.set("n", "<leader>cvi", ':call setreg("+", getreg("@"))<CR>', { desc = "Sync clipboard nvim => os" })
