vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",

	-- installation manager for DAP, LSP, Linter and Formatter
	"https://github.com/mason-org/mason.nvim",
	-- make mason and nvim-dap work better together
	"https://github.com/jay-babu/mason-nvim-dap.nvim",

	-- persist breakpoints accross sessions
	"https://github.com/Weissle/persistent-breakpoints.nvim",
})

require("mason").setup()

require("mason-nvim-dap").setup({
	ensure_installed = {
		"python",
		"codelldb",
		"javadbg",
		"delve",
	},
	automatic_installation = true,
})

require("persistent-breakpoints").setup({
	load_breakpoints_event = { "BufReadPost" },
})

vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { desc = "Debug: Start / Continue" })
vim.keymap.set("n", "<F11>", ":DapStepInto<CR>", { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F10>", ":DapStepOver<CR>", { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F12>", ":DapStepOut<CR>", { desc = "Debug: Step Out" })
vim.keymap.set("n", "<F7>", ":DapViewToggle<CR>", { desc = "Debug: Toggle Last Session Result" })

-- breakpoint maps
vim.keymap.set("n", "<leader>b", ":PBToggleBreakpoint<CR>", { desc = "Debug: Toggle [B]reakpoint" })
vim.keymap.set("n", "<leader>Bdd", ":PBClearAllBreakpoints<CR>", { desc = "Clear All Breakpoints" })
vim.keymap.set("n", "<leader>Bc", ":PBSetConditionalBreakpoint<CR>", { desc = "Set [C]onditional [B]reakpoint" })
vim.keymap.set("n", "<leader>Bl", ":PBSetLogPoint<CR>", { desc = "Set [L]ogpoint" })
