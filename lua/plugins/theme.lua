return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			-- vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			-- vim.cmd.colorscheme("tokyonight")
			-- vim.cmd.colorscheme("tokyonight-night")
			-- vim.cmd.colorscheme("tokyonight-storm")
			-- vim.cmd.colorscheme("tokyonight-day")
			-- vim.cmd.colorscheme("tokyonight-moon")
		end,
	},
	{
		"svrana/neosolarized.nvim",
    dependencies = {
      "tjdevries/colorbuddy.vim",
    },
		priority = 1000,
		lazy = false,
		config = function()
			vim.cmd.colorscheme("neosolarized")
		end,
	},
}
