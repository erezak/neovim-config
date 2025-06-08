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
			-- vim.cmd.colorscheme("neosolarized")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = { bold = true },
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,1,...,15}
				colors = {},
				theme = "wave",
				background = {
					dark = "wave", -- dark theme
					light = "lotus", -- light theme
				},
			})
			-- vim.cmd.colorscheme("kanagawa")
		end,
	},
	{
		"Koalhack/darcubox-nvim",
		config = function()
			require("darcubox").setup({
				options = {
					transparent = true,
					styles = {
						comments = { italic = true }, -- italic
						functions = { bold = true }, -- bold
						keywords = { italic = true },
						types = { italic = true, bold = true }, -- italics and bold
					},
				},
			})

			vim.cmd([[colorscheme darcubox]])
			vim.cmd("highlight ColorColumn guibg=#333344")
      local status, lualine = pcall(require, "lualine")
			if not status then
				return
			end

			lualine.setup({
				options = {
					theme = "darcubox",
				},
			})
		end,
	},
}
