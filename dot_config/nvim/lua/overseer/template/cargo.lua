local overseer = require("overseer")

---@type overseer.TempalteFileDefinition
return {
	generator = function(_search)
		local templates = {}

		for _, profile in ipairs({ "dev", "release", "test", "bench" }) do
			table.insert(templates, {
				name = string.format("Cargo Build [%s]", profile),
				components = {
					"unique",
					"default",
				},
				builder = function()
					return {
						name = "Cargo Build",
						cmd = "cargo",
						args = { "build", "--profile", profile },
					}
				end,
				tags = { overseer.TAG.BUILD },
			})
		end

		return templates
	end,
}
