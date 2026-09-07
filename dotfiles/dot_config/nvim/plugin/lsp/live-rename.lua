vim.pack.add({
	"https://github.com/saecki/live-rename.nvim",
})

local lr = require("live-rename")
lr.setup({})

vim.keymap.set({ "n", "x" }, "<leader>nr", function()
	local clients_rename_support = vim.lsp.get_clients({bufnr = 0, method = vim.lsp.protocol.Methods.textDocument_rename})
	if not vim.tbl_isempty(clients_rename_support) then
		lr.rename({ cursorpos = 0 })
	else
		-- fallback to search and replace if an lsp does not exist which supports renaming
		vim.api.nvim_feedkeys("*:%s//", "n ", false)
	end
end, { desc = "[R]ename Symbol" })
