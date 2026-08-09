vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gdscript", "gdshader" },
	callback = function()
		-- actually tab for godot files, seems this is what godot likes most
		vim.opt_local.expandtab = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gdscript", "gdshader" },
	once = true,
	callback = function()
		vim.lsp.enable("godot")
	end,
})
