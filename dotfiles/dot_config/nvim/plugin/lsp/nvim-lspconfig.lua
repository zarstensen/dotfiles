vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	-- do i need this?
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	-- 3rd party lock file for mason packages
	{ src = "https://github.com/zarstensen/mason-lock.nvim", version = "opt-evlistener" },
	-- this is for auto installing mason stuff, so specify mason config in config files
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	-- extra capabilities for blink.cmp
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
})

-- TODO: where should this be? it is currently both here and in the dap config file.
require("mason").setup()

vim.keymap.set("n", "<C-b>", "<Plug>(nvim.lsp.ctrl-s)")

-- keymaps and other stuff to setup, whenever LSP is attached to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Rename the variable under your cursor.
		-- TODO: remove, replaced by live-rename
		-- map("<leader>nr", vim.lsp.buf.rename, "[R]ename Symbol")

		-- execute code action
		map("<leader>na", function()
			require("fzf-lua").lsp_code_actions()
		end, "List Code [A]ction", { "n", "x" })
		map("<leader>n.", function()
			require("fzf-lua").lsp_code_actions()
		end, "List Code [A]ction", { "n", "x" })

		-- List references of current symbol
		map("<leader>nR", function()
			require("fzf-lua").lsp_references()
		end, "List [R]eferences", { "n", "x" })

		map("<leader>nd", function()
			require("fzf-lua").lsp_definitions()
		end, "Goto [D]efinition")

		map("<leader>ni", function()
			require("fzf-lua").lsp_implementations()
		end, "Goto [I]mplementation")

		map("<leader>nt", function()
			require("fzf-lua").lsp_typedefs()
		end, "Goto [T]ype Definition")

		map("<leader>ns", function()
			require("fzf-lua").lsp_document_symbols()
		end, "List Buffer [S]ymbols")

		map("<leader>nws", function()
			require("fzf-lua").lsp_live_workspace_symbols()
		end, "List [W]orkspace [S]ybmols")

		map("<leader>nI", function()
			require("fzf-lua").lsp_incoming_calls()
		end, "List [I]ncoming Calls")

		map("<leader>nO", function()
			require("fzf-lua").lsp_outgoing_calls()
		end, "List [O]utgoing Calls")

		map("<leader>nk", function()
			vim.lsp.buf.hover({
				title = "Inspect",
				title_pos = "left",
				border = "single",
				max_height = 25,
				max_width = 120,
			})
		end, "Hover Symbol")
		map("<leader>nK", function()
			vim.lsp.buf.signature_help({
				title = "Signature",
				title_pos = "left",
				border = "single",
				max_height = 25,
				max_width = 120,
			})
		end, "Signature Help")

		map("<leader>npk", function()
			vim.lsp.buf.hover({
				title = "Inspect",
				title_pos = "left",
				border = "single",
				max_height = 25,
				max_width = 120,
				close_events = {},
			})
		end, "Hover Symbol")
		map("<leader>npK", function()
			vim.lsp.buf.signature_help({
				title = "Signature",
				title_pos = "left",
				border = "single",
				max_height = 25,
				max_width = 120,
				close_events = {},
			})
		end, "Signature Help")
		map("<leader>nS", function()
			vim.lsp.buf.selection_range(1)
		end, "[S]election Range")

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is execued
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			local hl_deb = require("utils.debounce"):new(1000)
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = hl_deb:debounced(vim.lsp.buf.document_highlight),
			})

			local cr_deb = require("utils.debounce"):new(1000)
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = cr_deb:debounced(vim.lsp.buf.clear_references),
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({
						group = "kickstart-lsp-highlight",
						buffer = event2.buf,
					})
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			vim.lsp.inlay_hint.enable(true)
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
					bufnr = event.buf,
				}))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
})

-- Ensure the servers and tools above are installed
--
-- To check the current status of installed tools and/or manually install
-- other tools, you can run
--    :Mason
--
-- You can press `g?` for help in this menu.
--
-- `mason` had to be setup earlier: to configure its options see the
-- `dependencies` table for `nvim-lspconfig` above.
--
-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
-- TODO: this needs to be cleaned up a bit...
local ensure_installed = vim.tbl_keys(servers or {})

vim.list_extend(ensure_installed, {
	"stylua", -- Used to format Lua code
})

require("mason-lock").setup({})

-- TODO: why is this better than ensure_installed in mason-lspconfig?
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("mason-lspconfig").setup({
	ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
	automatic_enable = true,
})

-- disable file watching
local capabilities = vim.lsp.protocol.make_client_capabilities()
if capabilities.workspace then
	capabilities.workspace.didChangeWatchedFiles = nil
end
vim.lsp.config("*", {
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
})
