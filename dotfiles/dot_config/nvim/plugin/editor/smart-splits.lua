vim.pack.add({
	"https://github.com/mrjones2014/smart-splits.nvim",
})

local ssp = require("smart-splits")
ssp.setup({ resize = { amount = 2 } })

vim.keymap.set("n", "<M-h>", ssp.resize_left)
vim.keymap.set("n", "<M-j>", ssp.resize_down)
vim.keymap.set("n", "<M-k>", ssp.resize_up)
vim.keymap.set("n", "<M-l>", ssp.resize_right)

-- Grow the current window by `percent`% (50 -> 150% of its current size).
-- smart-splits' direction depends on which edge the window is on, so flip at
-- the right/bottom edge to make sure we always grow rather than shrink.
---@param axis "width"|"height"
---@param percent number percentage of the current size to add
local function grow(axis, percent)
	local at_end
	local size
	if axis == "width" then
		at_end = vim.fn.winnr() == vim.fn.winnr("l")
		size = vim.api.nvim_win_get_width(0)
	else
		at_end = vim.fn.winnr() == vim.fn.winnr("j")
		size = vim.api.nvim_win_get_height(0)
	end
	local amount = math.max(1, math.floor(size * percent / 100))

	if axis == "width" then
		(at_end and ssp.resize_left or ssp.resize_right)({ amount = amount })
	else
		(at_end and ssp.resize_up or ssp.resize_down)({ amount = amount })
	end
end

vim.keymap.set("n", "<C-w>1", function() grow("width", 50) end, { desc = "Widen window by 50%" })
vim.keymap.set("n", "<C-w>2", function() grow("width", 100) end, { desc = "Widen window by 100%" })
-- vim.keymap.set("n", "<C-w>1", function() grow("height", 50) end, { desc = "Make window 50% taller" })
