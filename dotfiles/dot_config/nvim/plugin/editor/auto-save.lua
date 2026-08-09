if vim.fn.has("win32") then
	return
end

vim.pack.add({
	"https://github.com/pocco81/auto-save.nvim",
})

local exclude_ft = {
	-- godot
	"gdscript",
	"gdshader",
}

local exclude_fn = {
	".nvim.lua",
}

require("auto-save").setup({
	-- this is just copied from default config, and the empty exclusion list has been replaced by exclude_ft.
	condition = function(buf)
		local fn = vim.fn
		local utils = require("auto-save.utils.data")

		if
			fn.getbufvar(buf, "&modifiable") == 1
			and utils.not_in(fn.getbufvar(buf, "&filetype"), exclude_ft)
			and vim.api.nvim_buf_get_name(buf)
		then
			return true -- met condition(s), can save
		end
		return false -- can't save
	end,
	-- increased interval of no-op before an autosave is performed
	debounce_delay = 1000,
})
