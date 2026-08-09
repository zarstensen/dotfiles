vim.pack.add({
    "https://github.com/jedrzejboczar/exrc.nvim"
})

require("exrc").setup({min_log_level = vim.log.levels.WARN})
