-- Rust-specific debug keymaps.
--
-- `:DapContinue` only replays nvim-dap's cached configuration, which points
-- at the executable rustaceanvim built when rust-analyzer attached. It does
-- not rebuild, so edits are ignored on subsequent presses.
-- `:RustLsp! debuggables` runs `cargo build` before every session.
-- Buffer-local, so the global nvim-dap mappings are untouched.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function(event)
		local function rust_debug()
			-- `!` rebuilds and reuses the last debuggable; on the first run it
			-- falls back to the debuggables picker.
			return pcall(vim.cmd, "RustLsp! debuggables")
		end

		vim.keymap.set("n", "<F5>", function()
			local dap = require("dap")

			if dap.session() then
				return dap.continue()
			end

			if not rust_debug() then
				dap.continue()
			end
		end, { buffer = event.buf, desc = "Debug: Start / Continue" })

		vim.keymap.set("n", "<F17>", function()
			local dap = require("dap")

			if dap.session() then
				return dap.terminate()
			end

			if not rust_debug() then
				dap.run_last()
			end
		end, { buffer = event.buf, desc = "Debug: Rerun / Terminate" })
	end,
})
