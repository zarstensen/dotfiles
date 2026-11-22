vim.pack.add({ "https://github.com/gbprod/cutlass.nvim" })


require("cutlass").setup({
	exclude = {"nD", "xD", "nS", "xS"},
	override_del = true,
})

-- D is the cut operator: it behaves like native `d` (yanks).
-- Mapping it in `o` mode too makes `DD` work like `dd`.
vim.keymap.set({ "n", "x", "o" }, "D", "d")

-- p pastes without yanking, P pastes with yanking
vim.keymap.set("x", "p", "P")
vim.keymap.set("x", "P", "p")
