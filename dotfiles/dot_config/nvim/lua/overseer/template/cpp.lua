local overseer = require("overseer")

local flags = {
	debug = { "-g", "-O0", "-Wall" },
	release = { "-O3", "-Wall" },
}

local outdirs = {
	debug = "out/debug",
	release = "out",
}

local function build_current_file_templates()
	local templates = {}
	for _, mode in ipairs({ "debug", "release" }) do
		table.insert(templates, {
			name = string.format("g++ Build [%s]", mode),
			components = {
				"unique",
				"default",
			},
			builder = function()
				local file = vim.fn.expand("%:p")
				if file == "" or not file:match("%.%a+$") then
					vim.notify("No file found to build", vim.log.levels.WARN, { title = "g++ Build" })
					return {}
				end

				local dir = vim.fs.dirname(file)
				local outfile = vim.fn.fnamemodify(file, ":t:r")
				local outdir = dir .. "/" .. outdirs[mode]
				local output = outdir .. "/" .. outfile
				vim.fn.mkdir(outdir, "p")

				return {
					name = string.format("g++ Build [%s] %s", mode, vim.fn.fnameescape(file)),
					cmd = "g++",
					args = vim.list_extend(vim.deepcopy(flags[mode]), {
						file,
						"-o",
						output,
					}),
					cwd = dir,
				}
			end,
			tags = { overseer.TAG.BUILD },
		})
	end
	return templates
end

local function build_make_file()
	local templates = {}
	for _, mode in ipairs({ "debug", "release" }) do
		table.insert(templates, {
			name = string.format("Make Build [%s]", mode),
			components = {
				"unique",
				"default",
			},
			builder = function()
				local file = vim.fn.expand("%:p")
				if file == "" or not file:match("%.%a+$") then
					vim.notify("No file found to build", vim.log.levels.WARN, { title = "Make Build" })
					return {}
				end

				return {
					name = string.format("Make Build [%s] %s", mode, vim.fn.fnameescape(file)),
					cmd = "make",
					args = { mode, "-j" },
					cwd = vim.fs.dirname(file),
				}
			end,
			tags = { overseer.TAG.BUILD },
		})
	end
	return templates
end

---@type overseer.TemplateFileDefinition
return {
	generator = function(_search)
		return vim.list_extend(build_current_file_templates(), build_make_file())
	end,
}
