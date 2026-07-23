if true then
    return
end

vim.pack.add({
	"https://github.com/folke/sidekick.nvim",
})

local utils = require("utils")

local sk = require("sidekick")
local sk_cli = require("sidekick.cli")

sk.setup({
	nes = { enabled = false },
	cli = {
		mux = {
			backend = "zellij",
			enabled = false,
		},
		win = {
			split = {
				width = 50,
			},
			keys = {
				buffers = { "<a-b>", "buffers", mode = "nt", desc = "open buffer picker" },
				files = { "<a-f>", "files", mode = "nt", desc = "open file picker" },
			},
		},
		tools = {
			copilot = {
				cmd = { "copilot", "--model", "gpt-5-mini" }, -- do not show banner animation when opening copilot.
			},
		},
	},
})

vim.keymap.set({ "n", "x" }, "<leader>hs", function()
	sk_cli.toggle({ name = "copilot" })
end, { desc = "[S]how / Hide Copilot Chat Window" })

vim.keymap.set("x", "<leader>hv", function()
	sk_cli.send({ msg = "{selection}" })
end, { desc = "Send [V]isual Selection" })

vim.keymap.set({ "n", "x" }, "<leader>hf", function()
	sk_cli.send({ msg = "{file}" })
end, { desc = "Send [F]ile" })

vim.keymap.set({ "n", "x" }, "<leader>ht", function()
	local diag_msg = utils.get_diag_on_line()
	local msg = "{this}"

	if diag_msg ~= nil then
		msg = msg .. "\n" .. diag_msg
	end

	sk_cli.send({ msg = msg })
end, { desc = "Send This" })

vim.keymap.set({ "n", "x" }, "<leader>hp", function()
	sk_cli.prompt()
end, { desc = "Select Prompt" })
