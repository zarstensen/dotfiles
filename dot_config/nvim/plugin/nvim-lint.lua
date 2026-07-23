vim.pack.add({
	"https://github.com/mfussenegger/nvim-lint",
})

local lt = require("lint")

-- -- Optional hook: print raw linter output using a Lua function. You can
-- -- override `lt.print_raw_output` in your config if you want a different
-- -- behaviour (for example open a scratch window, send to Telescope, etc.).
-- if not lt.print_raw_output then
--     lt.print_raw_output = function(output, bufnr, linter_cwd)
--         -- Schedule on main loop to be safe (read callbacks may run off-main)
--         vim.schedule(function()
--             local header = string.format("=== nvim-lint raw output | bufnr=%s cwd=%s",
--                 tostring(bufnr), tostring(linter_cwd))
--             -- Print to Neovim message area; this goes to :messages and the UI
--             print(header .. "\n")
--             print(output .. "\n\n")
--         end)
--     end
-- end
--
-- -- Wrap the parser accumulator so we can call `lt.print_raw_output` with
-- -- the full tool output right before the original parser publishes
-- -- diagnostics. This preserves original behaviour but allows inspecting
-- -- the raw linter output in the message area.
-- do
--     local ok, parser = pcall(require, 'lint.parser')
--     if ok and parser and parser.accumulate_chunks then
--         local orig_accumulate = parser.accumulate_chunks
--         parser.accumulate_chunks = function(parse)
--             local orig = orig_accumulate(parse)
--             local chunks = {}
--             return {
--                 on_chunk = function(chunk)
--                     table.insert(chunks, chunk)
--                     if orig.on_chunk then
--                         orig.on_chunk(chunk)
--                     end
--                 end,
--                 on_done = function(publish, bufnr, linter_cwd)
--                     local output = table.concat(chunks)
--                     if output and output ~= "" then
--                         pcall(function()
--                             lt.print_raw_output(output, bufnr, linter_cwd)
--                         end)
--                     end
--                     if orig.on_done then
--                         orig.on_done(publish, bufnr, linter_cwd)
--                     end
--                 end,
--             }
--         end
--     end
-- end

lt.linters_by_ft = {
	python = { "dmypy" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "BufEnter" }, {
	callback = function()
		-- Start fidget progress for linting so it appears in the Fidget UI
		local ok_fidget, fprogress = pcall(require, "fidget.progress")
        local progress
		if ok_fidget then
			progress = fprogress.handle.create({
				title = "Lint",
				message = "starting",
				lsp_client = { name = "nvim-lint" },
			})
		end

		-- Trigger linting
		lt.try_lint()

		if ok_fidget then
			-- If we created a progress handle, poll running linters and update it
			-- Use a chained single-shot approach (vim.defer_fn) instead of a
			-- repeating uv timer. This ensures the next poll is scheduled only
			-- after the current callback has finished executing, avoiding
			-- overlapping/simultaneous callbacks and "already closing" errors.
			local max_checks = 300 -- 300 * 100ms = 30s timeout guard
			local checks = 0

			local function poll()
				checks = checks + 1
				local running = lt.get_running() or {}
				if #running == 0 or checks >= max_checks then
					-- finish and cleanup the progress handle if present
					pcall(function()
						if progress and progress.finish then
							progress:finish()
						end
					end)
					return
				end

				-- update message with running linters
				local msg = table.concat(running, ", ")
				pcall(function()
					if progress and progress.report then
						progress:report({ message = msg })
					end
				end)

				-- schedule next poll after 100ms on the main loop; since this is
				-- done at the end of the callback, we won't schedule another poll
				-- until this one has completed.
				vim.defer_fn(poll, 100)
			end

			-- start first poll immediately
			poll()
		end
	end,
})
