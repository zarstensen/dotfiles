require('utils.lload')('BufEnter', function()
    vim.pack.add({
        "https://github.com/nvim-lua/plenary.nvim",

        "https://github.com/folke/todo-comments.nvim",
    })

    require("todo-comments").setup()
end)
