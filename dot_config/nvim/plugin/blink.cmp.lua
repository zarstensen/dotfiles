require("utils.lload")('InsertEnter', function()
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
})

require("blink.cmp").setup({
	-- cmdline auto completion is very slow for windows, so disable.
	cmdline = { enabled = vim.fn.has("win32") == 0 },
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "lazydev" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
		},
	},
	keymap = {
		preset = "super-tab",
		["<C-K>"] = false, -- unbind toggle signature
		["<C-Y>"] = false, -- unbind accept autocomplete
		-- ["<TAB>"] = { "select_and_accept", "fallback" },
		-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
		--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
	},
})
-- TOOD: test
end)
