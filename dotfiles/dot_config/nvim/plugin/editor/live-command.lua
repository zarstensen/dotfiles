-- live preview of commands so norm is more usable
vim.pack.add({
	"https://github.com/smjonas/live-command.nvim",
})

require("live-command").setup({
	commands = {
		Norm = {
			cmd = "norm",
		},
	},
})
