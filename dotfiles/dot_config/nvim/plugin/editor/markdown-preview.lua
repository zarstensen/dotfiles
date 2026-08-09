vim.pack.add({
	"https://github.com/iamcco/markdown-preview.nvim",
})

vim.g.mkdp_filetypes = { "markdown" }
vim.g.mkdp_theme = "dark"

-- autocall TSUpdate when treesitter is updated
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(pack)
		local name, kind = pack.data.spec.name, pack.data.kind
		if name == "markdown-preview" and kind == "update" then
			vim.fn["mkdp#util#install"]()
		end
	end,
})
