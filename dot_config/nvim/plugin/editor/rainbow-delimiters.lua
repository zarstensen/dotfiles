vim.pack.add({
	"https://github.com/HiPhish/rainbow-delimiters.nvim",
})

require("rainbow-delimiters.setup").setup({
	highlight = {
		"RainbowDelimiterYellow",
		"RainbowDelimiterBlue",
		"RainbowDelimiterGreen",
		"RainbowDelimiterViolet",
		"RainbowDelimiterCyan",
		"RainbowDelimiterOrange",
	},
})
