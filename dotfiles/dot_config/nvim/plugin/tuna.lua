
vim.pack.add({ "https://github.com/FrancescoDerme/tuna.nvim" })
require("tuna").setup({
	scaffold = {
		templates = vim.fn.stdpath("config") .. "/plugin/other/tuna/scaffolds/$(ROLE).$(FEXT)",
	},
})
