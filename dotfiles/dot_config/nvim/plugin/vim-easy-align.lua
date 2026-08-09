require('utils.lload')(
    'BufEnter',
    function()
        vim.pack.add({ "https://github.com/junegunn/vim-easy-align.git" })
        vim.g.easy_align_ignore_groups = { "string" }
        -- NOTE: this should probably not have a whole keymap dedicated to it?
        vim.keymap.set({ "n", "x" }, "ga", "<Plug>(EasyAlign)", { desc = "Start Easy[A]lign" })
    end)

