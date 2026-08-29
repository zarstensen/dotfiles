vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",

	"https://github.com/ibhagwan/fzf-lua",
})

local fzf = require("fzf-lua")

local file_cont_fzf_opts = {
	fzf_opts = {
		-- rg outputs 'path : line no : content' and we only want to search content, but display all 3
		-- so we achieve this with the following additional fzf flags
		["--nth"] = "3..",
		["--with-nth"] = "1..",
		["--delimiter"] = ":",
	},
}

local config = {
	ui_select = {},
	grep = {
		rg_opts = "--hidden --column --line-number --no-heading --color=always --follow",
	},
}

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	config.files = {
		cmd = [[rg --files]],
		multiprocess = false,
		file_icons = false,
		color_icons = false,
	}
end

fzf.setup(config)

-- keymaps for picker
vim.keymap.set("n", "<leader>sh", fzf.helptags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>s/", fzf.lgrep_curbuf, { desc = "[S]earch [/]Current Buffer" })
vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sj", fzf.jumps, { desc = "[S]earch [J]ump List" })
vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "[S]earch [M]arks" })
vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "[S]earch [D]iagnostics (Workspace)" })
vim.keymap.set("n", "<leader>sb", fzf.git_branches, { desc = "[S]earch Git [B]ranches" })
vim.keymap.set("n", "<leader>sw", function()
	fzf.grep_cword(vim.tbl_deep_extend("force", config, file_cont_fzf_opts))
end, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sW", function()
	fzf.grep_cWORD(vim.tbl_deep_extend("force", config, file_cont_fzf_opts))
end, { desc = "[S]earch current [W]ORD" })
vim.keymap.set("n", "<leader>sg", function()
	fzf.grep(vim.tbl_deep_extend("force", config, file_cont_fzf_opts, { search = "" }))
end, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", '<leader>s"', fzf.registers, { desc = '[S]earch (["]) Registers' })
vim.keymap.set("n", "<leader>s.", fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
-- vim.keymap.set("n", "<leader>sc", fzf.ou, { desc = "[S]earch [C]LI Tool Output" })
vim.keymap.set("n", "<leader>s<leader>", fzf.buffers, { desc = "[s] Find existing buffers" })
vim.keymap.set("n", "<leader><leader>", fzf.global, { desc = "[ ] Global Search" })
vim.keymap.set("n", "<leader>st", fzf.treesitter, { desc = "[S]earch [T]ree-Sitter Nodes" })
