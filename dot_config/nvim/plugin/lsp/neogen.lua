vim.pack.add({
    "https://github.com/danymat/neogen"
})

local ng = require("neogen")

ng.setup({})

vim.keymap.set("n", "<leader>nc", ng.generate, { desc = "Generate Docstring" })
