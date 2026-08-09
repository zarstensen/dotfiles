local utils = require("utils")
-- yank stuff into "y register pr. default,and also paste from here
-- vim.keymap.set({ "n", "v" }, "y", '"yy')
-- vim.keymap.set({ "n", "v" }, "p", '"yp')
-- vim.keymap.set({ "n", "v" }, "P", '"yP')
-- vim.keymap.set({ "n", "v" }, "dp", '"+p')
-- vim.keymap.set({ "n", "v" }, "dP", '"+P')

vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>", { desc = "Set working directory" })

vim.keymap.set("n", "<PageDown>", "<C-D>", { desc = "Half page down" })
vim.keymap.set("n", "<PageUp>", "<C-U>", { desc = "Half page up" })
vim.keymap.set("n", "<S-J>", "<C-D>", { desc = "Half page down" })
vim.keymap.set("n", "<S-K>", "<C-U>", { desc = "Half page up" })
-- TODO: remove these?`dont really use them, and it is more usefull to be able to move between windows
-- vim.keymap.set("i", "<C-H>", "<C-O>h", { desc = "Move left" })
-- vim.keymap.set("i", "<C-J>", "<C-O>j", { desc = "Move down" })
-- vim.keymap.set("i", "<C-K>", "<C-O>k", { desc = "Move up" })
-- vim.keymap.set("i", "<C-L>", "<C-O>l", { desc = "Move right" })

vim.keymap.set("n", "gw", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "[G]oto Next Diagnostics" })
vim.keymap.set("n", "gW", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "[G]oto Previous Diagnostics" })

vim.keymap.set("n", "<S-ø>", "AAA")

-- window resizing
-- NOTE: superseeded by smart-splits
-- local resize_speed = 2
-- vim.keymap.set("n", "<M-j>", string.format(":res +%d<CR>", resize_speed))
-- vim.keymap.set("n", "<M-k>", string.format(":res -%d<CR>", resize_speed))
-- vim.keymap.set("n", "<M-l>", string.format(":vert res +%d<CR>", resize_speed))
-- vim.keymap.set("n", "<M-h>", string.format(":vert res -%d<CR>", resize_speed))

-- local resize_helper = function(win_cmd, res_cmd)
-- 	return function()
-- 		local win_nr = vim.fn.winnr(win_cmd)
-- 		vim.cmd(("%s"):format(res_cmd):format(win_nr, resize_speed))
-- 	end
-- end

-- vim.keymap.set("n", "<A-S-j>", resize_helper("1h", "%dres -%d<CR>"))
-- vim.keymap.set("n", "<A-S-k>", resize_helper("1h", "%dres +%d<CR>"))
-- vim.keymap.set("n", "<A-S-l>", resize_helper("1k", "vert %dres +%d<CR>"))
-- vim.keymap.set("n", "<A-S-r>", resize_helper("1k", "vert %dres -%d<CR>"))

vim.api.nvim_create_user_command("Settab", function(opts)
	local ts = tonumber(opts.args) or 4
	vim.cmd(string.format("setlocal expandtab tabstop=%d shiftwidth=%d softtabstop=%d", ts, ts, ts))
	vim.cmd("retab")
end, {
	nargs = 1,
	complete = function()
		return { "2", "4", "8" }
	end,
})

vim.api.nvim_create_user_command("ConfigReload", function()
	vim.cmd(":source $MYVIMRC")
end, {
	nargs = 0,
})

vim.api.nvim_create_user_command("Dash", function()
	Snacks.dashboard()
end, {
	nargs = 0,
})

vim.api.nvim_create_user_command("Update", function()
	vim.pack.update()
end, {
	nargs = 0,
})

vim.api.nvim_create_user_command("Purge", function()
    local should_del_def = nil
	for _, pack in ipairs(vim.pack.get()) do
		if not pack.active then
			local should_del = should_del_def
			while should_del == nil do
				local answer = vim.fn.input("Delete '" .. pack.spec.name .. "'? (y/n): ")

				if answer:lower() == "y" then
					should_del = true
				elseif answer:lower() == "n" then
					should_del = false
				end

                if answer == "Y" or answer == "N" then
                    should_del_def = should_del
                end
			end

            if should_del then
                print("Deleting '" .. pack.spec.name .. "'")
			    vim.pack.del({ pack.spec.name })
            else
                print("Skipping '" .. pack.spec.name .. "'")
            end
		end
	end
end, {
	nargs = 0,
})

vim.keymap.set("n", "yd", function()
	vim.fn.setreg("+", utils.get_diag_on_line())
end, { desc = "Yank diagnostic" })
