return {
	"folke/persistence.nvim",
	config = function()
		require("persistence").setup()
		vim.api.nvim_create_autocmd("DirChanged", {
			callback = function()
				-- Loads session for new working directory (if one exists)
				require("persistence").load()
			end,
		})
		if vim.fn.argc() == 0 then
			require("persistence").load()
		end
	end,
}
