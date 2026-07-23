-- autocall TSUpdate when treesitter is updated
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(pack)
		local name, kind = pack.data.spec.name, pack.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

local lockfile_path = vim.fn.stdpath("config") .. "/treesitter-lock.json"

local ts = require("nvim-treesitter")

ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

-- load parsers from lockfile
-- TODO: support multiple lines in lockfile? also pretty print lockfile contents.
local success, serialized_inst_parsers = pcall(vim.fn.readfile, lockfile_path)
local locked_parsers = {}

if success then
	locked_parsers = vim.fn.json_decode(serialized_inst_parsers)
end

ts.install(locked_parsers)

-- Try to enable treesitter for the current buffer,
-- fail quietly if file type is not supported by treesitter.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) then
			-- only enable remaining treesitter features, if highlighting is supported <==> language is installed.
			vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo[0][0].foldmethod = "expr"
			vim.wo[0][0].foldlevel = 99
			vim.wo[0][0].foldnestmax = 2
			vim.wo[0][0].foldtext = ""
			vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
		end
	end,
})

-- Save all currently installed parsers in a json file,
-- which are automatically installed on neovim startup.
vim.api.nvim_create_user_command("TSLock", function()
	local inst_parsers = ts.get_installed()
	table.sort(inst_parsers)
	local serialized_inst_parsers = vim.fn.json_encode(inst_parsers)
	vim.fn.writefile({ serialized_inst_parsers }, lockfile_path)
end, { nargs = 0 })
