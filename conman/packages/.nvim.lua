vim.schedule(function()
	local ovs = require("overseer")

	local install_packs_task = ovs.new_task({
		cmd = "chezmoi",
		args = { "apply", "--no-tty", "--force" },
		name = "Chezmoi Apply",
		strategy = { "jobstart", use_terminal = false },
	})
	install_packs_task:inc_reference()

	local src_file_path = debug.getinfo(1, "S").source:gsub("^@", "")
	local src_file_dir = vim.fn.fnamemodify(src_file_path, ":h")
	local packages_pattern = src_file_dir .. "/*.yaml"

	local deb = require("utils.debounce"):new(1000)
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = packages_pattern,
		callback = deb:debounced(function(_)
			install_packs_task:restart()
			vim.cmd(":OverseerOpen")
		end),
	})
end)
