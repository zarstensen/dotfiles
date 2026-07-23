-- TODO: fix border colors being too dark?
vim.pack.add({
	"https://github.com/alexvzyl/nordic.nvim",
})

local nordic = require("nordic")

nordic.setup({ visual = { bold = true } })

nordic.load({ bright_border = true, visual = { bold = true } })

if vim.g.vscode then
	vim.g.vscode_disable_nvimtree_bg = true
	return
end

vim.cmd.colorscheme("nordic")

local colors = require("nordic.colors.nordic")
local alpha_blend = require("utils").alpha_blend

local background = colors.gray0

local highlight_colors = {
	DapBreakpoint = colors.red.base,
	DapLogpoint = colors.yellow.base,
	DapStopped = colors.green.base,
}

for hl_name, hl_color in pairs(highlight_colors) do
	local dimmed_hl_color = alpha_blend(background, hl_color, 0.2)

	vim.api.nvim_set_hl(0, ("%sLine"):format(hl_name), { ctermbg = 0, bg = dimmed_hl_color })
	vim.api.nvim_set_hl(0, hl_name, { ctermbg = 0, fg = hl_color, bg = dimmed_hl_color })
end

local icons = {
	DapBreakpointCondition = { hl = "DapBreakpoint", icon = "" },
	DapBreakpointRejected = { hl = "DapBreakpoint", icon = "" },
	DapLogPoint = { hl = "DapLogpoint", icon = "" },
	DapStopped = { hl = "DapStopped", icon = "" },
	DapBreakpoint = { hl = "DapBreakpoint", icon = "" },
}

for sign_name, icon_config in pairs(icons) do
	vim.fn.sign_define(sign_name, {
		text = icon_config.icon,
		texthl = icon_config.hl,
		numhl = icon_config.hl,
		linehl = ("%sLine"):format(icon_config.hl),
	})
end
