return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ruff",
					"ts_ls",
					"clangd",
					"gopls",
					"tailwindcss",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.gopls.setup({
				settings = {
					gopls = {
						gofumpt = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
							fieldalignment = true,
						},
						staticcheck = true,
					},
				},
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayVariableTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayVariableTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			})
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					spacing = 2,
				},
				signs = true, -- show signs in the gutter (✓ you already see the "W")
				underline = true, -- underline the offending code
				update_in_insert = false, -- don't show warnings while typing
				severity_sort = true, -- sort by severity in list view
			})

			lspconfig.pyright.setup({
				capabilities = capabilities,
			})
			lspconfig.ruff.setup({
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
				capabilities = capabilities,
			})

			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})
			lspconfig.kotlin_language_server.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							-- checkThirdParty = false,
							library = {
								[vim.env.VIMRUNTIME] = true,
							},
							type = {
								cast_tostring = true,
							},
						},
						-- telemetry = { enable = false }, -- Optional: disable telemetry
					},
				},
			})
			lspconfig.zls.setup({
				capabilities = capabilities,
				cmd = { os.getenv("ZLS_BUILD_PATH") or "zls" },
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set(
						"n",
						"<leader>d",
						vim.diagnostic.open_float,
						{ buffer = ev.buf, desc = "Show diagnostics" }
					)
				end,
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.eslint_d.with({
						condition = function(utils)
							return utils.root_has_file({
								".eslintrc.js",
								".eslintrc.cjs",
								".eslintrc.json",
								".eslintrc",
							})
						end,
					}),
				},
			})
		end,
	},
	{
		"vim-scripts/android.vim",
	},
}
