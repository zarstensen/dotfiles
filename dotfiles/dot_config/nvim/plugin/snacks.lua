vim.pack.add({
	"https://github.com/folke/snacks.nvim",
})

local dashboard = { enabled = false }

if not vim.g.vscode then
	dashboard = {
		enabled = true,
		preset = {
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{
					icon = " ",
					key = "c",
					desc = "Config",
					action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
				},
				{ icon = " ", key = "s", desc = "Restore Session", action = ":AutoSession search" },
				{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{
				pane = 2,
				section = "terminal",
				cmd = "echo Terminal Section",
				height = 5,
				padding = 1,
			},
			{ section = "keys", gap = 1, padding = 1 },
			{
				pane = 2,
				icon = " ",
				title = "Recent Files",
				section = "recent_files",
				indent = 2,
				padding = 1,
			},
			{
				pane = 2,
				icon = " ",
				title = "Git Status",
				section = "terminal",
				enabled = function()
					return Snacks.git.get_root() ~= nil
				end,
				cmd = "git status --short --branch --renames",
				height = 5,
				padding = 1,
				ttl = 5 * 60,
				indent = 3,
			},
			-- { section = "startup" },
		},
	}
else
	vim.g.snacks_animate = false
end

-- TODO: view marks somehow?

require("snacks").setup({
	dashboard = dashboard,
	bufdelete = {},
	bigfile = {},
	image = {},
	indent = {},
	-- NOTE: replaced with neogit
	-- lazygit = {},
	scroll = {},
	terminal = {},
	statuscolumn = {}, -- for showing marks on the left side
	notifier = { level = vim.log.levels.WARN }, -- larger notifications, maybe not?
	rename = {}, -- needed by neotree
})

-- terminal
vim.keymap.set("n", "<leader>tt", Snacks.terminal.toggle, { desc = "[T]oggle [T]erminal" })

-- notifier
vim.api.nvim_create_user_command("Notif", Snacks.notifier.show_history, { nargs = 0 })

vim.keymap.set("t", "<S-esc>", "<C-\\><C-n>")
