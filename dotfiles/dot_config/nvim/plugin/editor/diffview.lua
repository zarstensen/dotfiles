vim.pack.add({
	"https://github.com/sindrets/diffview.nvim.git",
})

local dv_keymaps = {
	{ "n", "<leader>ds", ":DiffviewClose<CR>", { desc = "Close [D]iff View" } },
	{ "n", "<leader>e", ":DiffviewToggleFiles<CR>", { desc = "Toggle Diff View File [E]xplorer" } },
}

require("diffview").setup({
	keymaps = {
		view = dv_keymaps,
		file_panel = dv_keymaps,
		file_history_panel = dv_keymaps,
	},
})

local function git_root()
	local root = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
	if vim.v.shell_error ~= 0 or type(root) ~= "string" or root == "" then
		return nil
	end
	return root
end

local function save_last_args(args)
	local root = git_root()
	if not root then
		return
	end
	local state = vim.g.DIFFVIEW_LAST_ARGS
	if type(state) ~= "table" then
		state = {}
	end
	state[root] = args
	vim.g.DIFFVIEW_LAST_ARGS = state
end

local function get_last_args()
	local root = git_root()
	if not root then
		return nil
	end
	local state = vim.g.DIFFVIEW_LAST_ARGS
	if type(state) ~= "table" then
		return nil
	end
	local args = state[root]
	return type(args) == "string" and args ~= "" and args or nil
end

vim.keymap.set("n", "<leader>ds", function()
	local lib = require("diffview.lib")
	if lib.get_current_view() then
		vim.cmd("DiffviewClose")
		return
	end
	local args = get_last_args()
	vim.cmd("DiffviewOpen" .. (args and (" " .. args) or ""))
end, { desc = "Toggle [D]iff View" })

vim.keymap.set("n", "<leader>dr", ":DiffviewRefresh<CR>", { desc = "[R]efresh [D]iff View" })
vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory<CR>", { desc = "Show [D]iff View [H]istory" })
vim.keymap.set("n", "<leader>dH", ":DiffviewFileHistory %<CR>", { desc = "Show [D]iff View Current File [H]istory" })

vim.keymap.set("n", "<leader>dB", function()
	local fzf = require("fzf-lua")
	local refs = vim.fn.systemlist({
		"git",
		"for-each-ref",
		"--sort=-committerdate",
		"--format=%(refname:short)",
		"refs/heads",
		"refs/remotes",
		"refs/tags",
	})
	if vim.v.shell_error ~= 0 then
		vim.notify("Diffview: failed to list git refs", vim.log.levels.WARN)
		return
	end

	local WT = "[Working Tree]"
	local seen, choices = {}, {}

	local function add(ref)
		if type(ref) == "string" and ref ~= "" and not seen[ref] then
			seen[ref] = true
			table.insert(choices, ref)
		end
	end

	add(WT)
	vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", "HEAD" })
	if vim.v.shell_error == 0 then
		add("HEAD")
	end
	add(vim.fn.systemlist({ "git", "branch", "--show-current" })[1])
	for _, ref in ipairs(refs) do
		add(ref)
	end

	if #choices == 0 then
		vim.notify("Diffview: no refs found", vim.log.levels.WARN)
		return
	end

	fzf.fzf_exec(choices, {
		prompt = "Base ref> ",
		fzf_opts = { ["--no-multi"] = true },
		actions = {
			["default"] = function(selected)
				local base = selected and selected[1]
				if not base or base == "" then
					return
				end

				fzf.fzf_exec(choices, {
					prompt = "Compare ref> ",
					fzf_opts = { ["--no-multi"] = true },
					actions = {
						["default"] = function(selected_cmp)
							local compare = selected_cmp and selected_cmp[1]
							if not compare or compare == "" then
								return
							end

							if base == compare then
								vim.notify("Diffview: pick different refs", vim.log.levels.WARN)
								return
							end

							local args
							if base == WT or compare == WT then
								local ref = base == WT and compare or base
								args = vim.fn.fnameescape(ref)
							else
								args = ("%s...%s"):format(vim.fn.fnameescape(base), vim.fn.fnameescape(compare))
							end

							save_last_args(args)
							vim.cmd("DiffviewOpen " .. args)
						end,
					},
				})
			end,
		},
	})
end, { desc = "[D]iff [B]ranch range" })
