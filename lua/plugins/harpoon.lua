return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local use_telescope_ui = false
    local harpoon = require("harpoon")
    harpoon:setup({})

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
    end

    if use_telescope_ui then
      vim.keymap.set("n", "<C-e>", function()
        toggle_telescope(harpoon:list())
      end)
    else
      vim.keymap.set("n", "<C-e>", function()
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
