vim.pack.add({ "https://github.com/julianolf/nvim-dap-lldb.git" })

local dap = require("dap")

require("dap-lldb").setup()

local function read_args()
	local args = vim.fn.input("Enter args: ")
	return vim.split(args, " ", { trimempty = true })
end

local function compile_current_file()
	local ext = vim.fn.expand("%:e")
	if vim.bo.filetype ~= "c" and vim.bo.filetype ~= "cpp" then
		return dap.ABORT
	end
	local compiler
	local std
	if vim.bo.filetype == "c" or ext == "c" then
		compiler = vim.fn.exepath("clang") ~= "" and "clang" or "gcc"
		std = "-std=c11"
	else
		compiler = vim.fn.exepath("clang++") ~= "" and "clang++" or "g++"
		std = "-std=c++17"
	end
	local outbin = vim.fn.tempname()
	local cmd = { compiler, "-g", "-O0", std, "-fdiagnostics-color=never", "-o", outbin, vim.fn.expand("%:p") }
	local err = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify(err, vim.log.levels.ERROR)
		return dap.ABORT
	end
	return outbin
end

local function make_config(name, with_args)
	local cfg = {
		name = name,
		type = "lldb",
		request = "launch",
		cwd = function()
			return vim.fn.getcwd()
		end,
		program = compile_current_file,
		stopOnEntry = false,
	}
	if with_args then
		cfg.args = read_args
	end
	return cfg
end

for _, ft in ipairs({ "c", "cpp" }) do
	dap.configurations[ft] = vim.list_extend(
		{
			make_config("Compile & debug current file"),
			make_config("Compile & debug current file (+args)", true),
		},
		dap.configurations[ft]
	)
end