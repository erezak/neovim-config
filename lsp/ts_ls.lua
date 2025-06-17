--@type vim.lsp.Config
return {
	cmd = "ts_ls",
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
	root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
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
}
