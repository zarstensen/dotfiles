vim.pack.add({
	"https://github.com/j-hui/fidget.nvim",
})

require("fidget").setup({
	-- Limit number of LSP progress messages shown
	lsp = {
		progress_ringbuf_size = 300,
	},
	progress = {
		display = {
			render_limit = 3,
		},
	},

	-- Notification subsystem controls rendering/wrapping and window size
	notification = {
		view = {
			reflow = false,
		},

		window = {
			-- enforce a max width of ~30 characters; fidget uses columns
			-- so this will generally keep each line to ~30 chars
			max_width = 20,
			-- enforce at most 3 lines in the notification window
			max_height = 7,
		},
	},
})
