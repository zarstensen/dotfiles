vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/m00qek/baleia.nvim",

	"https://github.com/neogitorg/neogit",
})

vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neo[g]it" })
vim.api.nvim_create_user_command("Git", "Neogit", { nargs = 0 })
