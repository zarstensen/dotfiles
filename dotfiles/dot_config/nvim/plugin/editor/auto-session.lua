if vim.g.vscode then
	return {}
end

vim.pack.add({
	"https://github.com/rmagatti/auto-session",
})

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

require("auto-session").setup({
	enabled = true,
	auto_create = false,
	auto_restore = true,
	auto_save = true,
	close_filetypes_on_save = {
		"checkhealth",
		"sidekick_terminal",
		"neotest-summary",
		"OverseerOutput",
		"OverseerList",
	},
})

vim.keymap.set("n", "<leader>Sd", ":AutoSession delete<CR>", { desc = "[D]elete [S]ession" })
vim.keymap.set("n", "<leader>Sw", ":AutoSession save<CR>", { desc = "[W]rite / Save [S]ession" })

vim.keymap.set("n", "<leader>ss", ":AutoSession search<CR>", { desc = "[S]earch [S]essions" })

vim.api.nvim_create_user_command("Restart", function()
	vim.cmd("AutoSession save")
	vim.cmd("restart")
end, { nargs = 0 })
