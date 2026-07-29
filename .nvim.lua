print("stuffing")
vim.schedule(function()
	local deb = require("utils.debounce"):new(1000)

	local ovs = require("overseer")

	local install_packs_task = ovs.new_task({
		cmd = "chezmoi",
		args = {"apply"},
		name = "Chezmoi Apply",
	})
	install_packs_task:inc_reference()

	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = ".chezmoidata/packages/*.yaml",
		callback = deb:debounced(function(_)
			install_packs_task:restart()
			vim.cmd(":OverseerOpen")
		end),
	})
end)
