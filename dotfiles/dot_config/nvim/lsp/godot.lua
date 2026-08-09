local gdscript_config = {
	capabilities = require("config.lsp-caps"),
	settings = {},
}

if vim.fn.has("win32") == 1 then
	gdscript_config["cmd"] = { "ncat", "localhost", "6005" }
end

return gdscript_config
