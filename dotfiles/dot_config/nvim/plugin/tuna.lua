local dir = vim.fs.dirname(vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p"))

vim.pack.add({ "https://github.com/FrancescoDerme/tuna.nvim" })
require("tuna").setup({
    scaffold = {
        templates = dir .. "/scaffolds/$(ROLE).$(FEXT)",
    },
})

