vim.pack.add({
    "https://github.com/kkoomen/vim-doge"
})

-- disable default mappings (insane this is enabled by default)
vim.api.nvim_set_var('doge_enable_mappings', 0)

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(pack)
		local name, kind = pack.data.spec.name, pack.data.kind
		if name == "vim-doge" and kind == "install" then
			vim.cmd(":call doge#install()")
		end
	end,
})


vim.keymap.set("n", "<leader>nc", "<Plug>(doge-generate)", { desc = "Generate Docstring" })
