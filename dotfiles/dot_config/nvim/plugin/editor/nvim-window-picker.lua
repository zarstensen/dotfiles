require("utils.lload")("WinEnter", function()
	vim.pack.add({
		"https://github.com/s1n7ax/nvim-window-picker",
	})

	local wp = require("window-picker")
	wp.setup({ hint = "floating-big-letter", selection_chars = "FJDKSLACMRUEIWOQP" })

	vim.keymap.set("n", "<C-W>p", function()
		local picked_window = wp.pick_window()
		if picked_window then
            vim.fn.win_gotoid(picked_window)
		end
	end, { desc = "[P]ick and move to window" })
end)
