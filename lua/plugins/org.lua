return {
	-- {
	-- 	"nvim-neorg/neorg",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	version = "*",
	-- 	opts = {
	-- 		load = {
	-- 			["core.defaults"] = {},
	-- 			["core.dirman"] = {
	-- 				config = {
	-- 					workspaces = {
	-- 						notes = "~/notes/general",
	-- 						journal = "~/notes/journal",
	-- 						aidev = "~/notes/aidev",
	-- 						example_gtd = "~/notes/gtd",
	-- 						personal = "~/notes/personal",
	-- 					},
	-- 					default_workspace = "notes",
	-- 				},
	-- 			},
	-- 			["core.integrations.nvim-cmp"] = {},
	-- 			["core.completion"] = {
	-- 				config = {
	-- 					engine = "nvim-cmp",
	-- 				},
	-- 			},
	-- 			["core.concealer"] = {
	-- 				config = {
	-- 					folds = false,
	-- 				},
	-- 			},
	-- 			["core.integrations.image"] = {},
	-- 			["core.latex.renderer"] = {},
	-- 			["core.export"] = {},
	-- 			["core.summary"] = {},
	-- 			["core.journal"] = {
	-- 				config = {
	-- 					workspace = "journal",
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		lazy = true,
		-- ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
			-- refer to `:h file-pattern` for more examples
			"BufReadPre "
				.. vim.fn.expand("~")
				.. "/vaults/personal/*.md",
			"BufReadPre " .. vim.fn.expand("~") .. "/vaults/work/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/vaults/personal/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/vaults/work/*.md",
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			"nvim-lualine/lualine.nvim",
			-- see above for full list of optional dependencies ☝️
		},
		config = function()
			require("obsidian").setup({
				workspaces = {
					{
						name = "personal",
						path = "~/vaults/personal",
					},
					{
						name = "work",
						path = "~/vaults/work",
					},
				},
				daily_notes = {
					folder = "journal",
					date_format = "%Y-%m-%d",
				},
				completion = {
					nvim_cmp = true,
				},
			})
			require("lualine").setup({
				sections = {
					lualine_x = {
						"g:obsidian",
					},
				},
			})
		end,
		keys = {
			{
				"<localleader>nn",
				"<cmd>ObsidianNew<CR>",
				mode = "n",
				desc = "New Obsidian note",
			},
			------

			-- HACK: Manage Markdown tasks in Neovim similar to Obsidian | Telescope to List Completed and Pending Tasks
			-- https://youtu.be/59hvZl077hM
			--
			-- If there is no `untoggled` or `done` label on an item, mark it as done
			-- and move it to the "## completed tasks" markdown heading in the same file, if
			-- the heading does not exist, it will be created, if it exists, items will be
			-- appended to it at the top lamw25wmal
			--
			-- If an item is moved to that heading, it will be added the `done` label
			{
				"<localleader>lt",
				function()
					Snacks.picker.grep({
						prompt = " ",
						search = "^\\s*- \\[ \\]",
						regex = true,
						live = false,
						dirs = { vim.fn.getcwd() },
						args = { "--no-ignore" },
						on_show = function()
							vim.cmd.stopinsert()
						end,
						finder = "grep",
						format = "file",
						show_empty = true,
						supports_live = false,
						layout = "ivy",
					})
				end,
				desc = "Find tasks"
			},
			{
				"<localleader>ld",
				function()
					Snacks.picker.grep({
						prompt = " ",
						search = "^\\s*- \\[x\\] `done:", -- also match blank spaces at the beginning
						regex = true,
						live = false,
						dirs = { vim.fn.getcwd() },
						args = { "--no-ignore" },
						on_show = function()
							vim.cmd.stopinsert()
						end,
						finder = "grep",
						format = "file",
						show_empty = true,
						supports_live = false,
						layout = "ivy",
					})
				end,
				desc = "Find completed tasks"
			},
		},
	},
}
