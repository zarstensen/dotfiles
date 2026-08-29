-- LSP for quickshell, mason qmlls is wierd so we set it up ourselves instead
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qml",
	once = true,
	callback = function()
		vim.lsp.enable("qmlls")
	end,
})
