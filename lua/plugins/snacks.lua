return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			local Snacks = require("snacks")
			Snacks.setup({
				---@class snacks.toggle.Config
				---@field icon? string|{ enabled: string, disabled: string }
				---@field color? string|{ enabled: string, disabled: string }
				---@field wk_desc? string|{ enabled: string, disabled: string }
				---@field map? fun(mode: string|string[], lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts)
				---@field which_key? boolean
				---@field notify? boolean
				toggle = {
					map = vim.keymap.set, -- keymap.set function to use
					which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
					notify = true, -- show a notification when toggling
					-- icons for enabled/disabled states
					icon = {
						enabled = " ",
						disabled = " ",
					},
					-- colors for enabled/disabled states
					color = {
						enabled = "green",
						disabled = "yellow",
					},
					wk_desc = {
						enabled = "Disable ",
						disabled = "Enable ",
					},
				},
			})
			Snacks.toggle({
				name = "AI Helpers Completion",
				color = {
					enabled = "azure",
					disabled = "orange",
				},
				get = function()
					return not require("copilot.client").is_disabled()
				end,
				set = function(state)
					if state then
						require("copilot.command").enable()
					else
						require("copilot.command").disable()
					end
				end,
			}):map("<leader>ta", {
				desc = "Toggle Copilot Completion",
			})
			Snacks.toggle({
				name = "Line Numbers",
				color = {
					enabled = "blue",
					disabled = "red",
				},
				get = function()
					return vim.wo.number
				end,
				set = function(state)
					vim.wo.number = state
					vim.wo.relativenumber = state
				end,
			}):map("<leader>tn", {
				desc = "Toggle Line Numbers",
			})
			Snacks.toggle({
				name = "LSP Virtual Text",
				get = function()
					return vim.diagnostic.config().virtual_text
				end,
				set = function(state)
					vim.diagnostic.config({ virtual_text = state })
				end,
			}):map("<leader>td", {
				desc = "Toggle LSP Diagnostics",
			})
			Snacks.toggle({
				name = "Color Column",
				get = function()
					return vim.wo.colorcolumn ~= ""
				end,
				set = function(state)
					vim.wo.colorcolumn = state and "80" or ""
				end,
			}):map("<leader>tc", {
				desc = "Toggle Color Column",
			})
			Snacks.toggle({
				name = "Search Highlight",
				get = function()
					return vim.o.hlsearch
				end,
				set = function(state)
					vim.o.hlsearch = state
				end,
			}):map("<leader>th", {
				desc = "Toggle Search Highlight",
			})
		end,
	},
}
