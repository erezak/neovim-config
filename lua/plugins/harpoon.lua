return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local normalize_list = function(t)
			local normalized = {}
			for _, v in pairs(t) do
				if v ~= nil then
					table.insert(normalized, v)
				end
			end
			return normalized
		end
		local use_snacks_picker = true
		local harpoon = require("harpoon")
		harpoon:setup({})

		if use_snacks_picker then
			vim.keymap.set("n", "<leader>hl", function()
				Snacks.picker({
					finder = function()
						local file_paths = {}
						local list = normalize_list(harpoon:list().items)
						for i, item in ipairs(list) do
							table.insert(file_paths, { text = item.value, file = item.value })
						end
						return file_paths
					end,
					win = {
						input = {
							keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
						},
						list = {
							keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
						},
					},
					actions = {
						harpoon_delete = function(picker, item)
							local to_remove = item or picker:selected()
							harpoon:list():remove({ value = to_remove.text })
							harpoon:list().items = normalize_list(harpoon:list().items)
							picker:find({ refresh = true })
						end,
					},
				})
			end)
		else
			vim.keymap.set("n", "<leader>hl", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)
		end
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<leader>aq", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<leader>aw", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<leader>ae", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<leader>ar", function()
			harpoon:list():select(4)
		end)
	end,
}
