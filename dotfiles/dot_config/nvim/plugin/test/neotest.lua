-- do not bother loading test utils unless we also have an lsp enabled?`
require("utils.lload")('LspAttach', function()
	vim.pack.add({
		-- dependencies
		"https://github.com/nvim-lua/plenary.nvim",
		-- TODO: disable all time (what it is now), or windows only
		-- "https://github.com/antoinemadec/FixCursorHold.nvim",
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/nvim-neotest/nvim-nio",

		"https://github.com/nvim-neotest/neotest",

		-- adapters

		-- golang
		"https://github.com/fredrikaverpil/neotest-golang",
		-- python
		"https://github.com/nvim-neotest/neotest-python",

		-- javascript / typescript
		"https://github.com/marilari88/neotest-vitest",
		-- java
		"https://github.com/nvim-java/nvim-java",
		"https://github.com/rcasia/neotest-java",
	})

	-- get neotest namespace (api call creates or returns namespace)
	local neotest_ns = vim.api.nvim_create_namespace("neotest")
	vim.diagnostic.config({
		virtual_text = {
			format = function(diagnostic)
				local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
				return message
			end,
		},
	}, neotest_ns)

	local nt = require("neotest")
	local nio = require("nio")

	-- TODO: do this in different files?
	nt.setup({
		adapters = {
			require("neotest-golang")({ runner = "gotestsum" }),
			require("neotest-python")({
				dap = { justMyCode = false, stopOnEntry = false }, -- TODO: should this be somewhere else?
				args = function(runner, position, strategy)
                    print(runner)
					if strategy == "dap" or (position and position.type ~= "dir") then
						return { "-n", "0" }
					end
					return {}
				end,
			}),
			require("neotest-vitest")({}),
			-- require("neotest-java"),
			-- require("rustaceanvim.neotest"),
		},
	})

	local function get_buf_adapter(bufnr)
		for _, adapter in ipairs(nt.state.adapter_ids()) do
			if nt.state.positions(adapter, { buffer = bufnr }) then
				return adapter
			end
		end
	end

	vim.keymap.set("n", "<leader>mr", nt.run.run, { desc = "[R]un Nearest Test" })
	vim.keymap.set("n", "<leader>mf", function()
		nt.run.run(vim.fn.expand("%"))
	end, { desc = "Run Tests In [F]ile" })
	vim.keymap.set("n", "<leader>mR", function()
		local adapter_for_file = get_buf_adapter(vim.api.nvim_get_current_buf())

		if not adapter_for_file then
			vim.notify("No neotest adapter found for current buffer", vim.log.levels.WARN)
			return
		end

		nt.run.run({ suite = true, adapter = adapter_for_file })
	end, { desc = "[R]un Suite For Current Buffer Adapter" })
	vim.keymap.set("n", "<leader>m<F5>", function()
		nt.run.run({ strategy = "dap" })
	end, { desc = "Debug Tests" })
	vim.keymap.set("n", "<leader>mx", nt.run.stop, { desc = "Stop Tests" })
	-- vim.keymap.set("n", "<leader>nn", "<cmd>lua require('neotest').run.attach()<cr>", opts)
	vim.keymap.set("n", "<leader>mo", nt.output.open, { desc = "View Test Result" })
	vim.keymap.set("n", "<leader>mp", nt.output_panel.toggle, { desc = "Toggle Test [P]anel" })

	vim.keymap.set("n", "<leader>ms", nt.summary.toggle, { desc = "Toggle [S]ummary Panel" })

	local nt_integrated_strat = require("neotest.client.strategies.integrated")

	vim.keymap.set("n", "<leader>mc", function()
		local adapter_for_file = get_buf_adapter(vim.api.nvim_get_current_buf())

		if not adapter_for_file then
			vim.notify("No neotest adapter found for current buffer", vim.log.levels.WARN)
			return
		end

		nt.run.run({
			suite = true,
			adapter = adapter_for_file,
			strategy = function(spec, context)
				local cov_ok, cov_args = pcall(require, "config.coverage." .. context.adapter.name)

				if not cov_ok then
					vim.notify(
						"Coverage is not configured or has errors for test adapter: "
							.. context.adapter.name
							.. "\n"
							.. cov_args, -- cov_args is err message now
						vim.log.levels.ERROR
					)
					return nil
				end

				vim.list_extend(spec.command, cov_args)
				local cov_strat = nt_integrated_strat(spec)

				nio.run(function()
					cov_strat.result()
					vim.cmd(":Coverage")
				end)

				return cov_strat
			end,
		})
	end, { desc = "Run Tests With [C]overage" })
end)
