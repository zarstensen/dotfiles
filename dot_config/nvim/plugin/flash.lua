require("utils.lload")("BufEnter", function()
	vim.pack.add({
		"https://github.com/folke/flash.nvim",
	})

	local flash = require("flash")

	flash.setup({
		highlight = { backdrop = false, matches = true },
		jump = { nohlsearch = true },
		modes = {
			search = { enabled = true },
			char = {
				jump_labels = false, -- true for the letters
				autohide = true,
				highlight = { backdrop = false },
			},
		},
	})

	vim.keymap.set({ "n", "x", "o" }, "S", flash.jump, { desc = "Flash" })
	vim.keymap.set({ "n", "x", "o" }, "ss", flash.treesitter, { desc = "Flash Treesitter" })
	vim.keymap.set("o", "r", flash.remote, { desc = "Remote Flash" })
	vim.keymap.set("o", "R", flash.treesitter_search, { desc = "Treesitter Search" })
	vim.keymap.set("c", "<c-s>", flash.toggle, { desc = "Toggle Flash Search" })
end)
