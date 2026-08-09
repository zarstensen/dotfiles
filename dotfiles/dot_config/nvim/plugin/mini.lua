vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
})

-- dont want the mini session plugin
vim.g.minisessions_disable = true

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require("mini.ai").setup({
	n_lines = 500,
	custom_textobjects = {
		B = require("mini.extra").gen_ai_spec.buffer(),
		c =
			-- Word with camel case support (also supports only Latin alphabet):
			{
				{
					"%u[%l%d]+%f[^%l%d]",
					"%f[%S][%l%d]+%f[^%l%d]",
					"%f[%P][%l%d]+%f[^%l%d]",
					"^[%l%d]+%f[^%l%d]",
				},
				"^().*()$",
			},
	},
})

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup({ n_lines = 500, highlight_duration = 3000,
  custom_surroundings = {
    [')'] = { output = { left = '(', right = ')' } },
    [']'] = { output = { left = '[', right = ']' } },
    ['}'] = { output = { left = '{', right = '}' } },
    ['>'] = { output = { left = '<', right = '>' } },
  },
})

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require("mini.statusline")
-- set use_icons to true if you have a Nerd Font
statusline.setup({
	use_icons = vim.g.have_nerd_font,
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local git = MiniStatusline.section_git({ trunc_width = 40 })
			local diff = MiniStatusline.section_diff({ trunc_width = 75 })
			local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
			local location = MiniStatusline.section_location({ trunc_width = 75 })
			local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

			-- Show the register letter when recording a macro (empty string otherwise)
			local reg = vim.fn.reg_recording()
			local recording = (reg ~= "") and ("rec: [" .. reg .. "]") or ""

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp, recording } },
				"%<", -- Mark general truncate point
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", -- End left alignment
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
	},
})
-- Redraw statusline on macro recording start/stop so indicator updates immediately
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
	group = vim.api.nvim_create_augroup("UserMiniStatuslineRecording", { clear = true }),
	callback = function()
		vim.cmd("redrawstatus")
	end,
})

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
	return "%2l:%-2v"
end

-- move statusline to the top
-- vim.g.use_winbar = false
-- vim.opt.laststatus = 2 -- hide bottom statusline
-- vim.opt.winbar = vim.opt.statusline:get() -- set top status line equal to the default bottom one
