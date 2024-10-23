return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim", "nvim-treesitter/nvim-treesitter-textobjects", },
    build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      -- I find auto open annoying, keep in mind setting this option will require setting
      -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
      vim.g.molten_auto_open_output = false

      -- this guide will be using image.nvim
      -- Don't forget to setup and install the plugin if you want to view image outputs
      vim.g.molten_image_provider = "image.nvim"

      -- optional, I like wrapping. works for virt text and the output window
      vim.g.molten_wrap_output = true

      -- Output as virtual text. Allows outputs to always be shown, works with images, but can
      -- be buggy with longer images
      vim.g.molten_virt_text_output = true

      -- this will make it so the output shows up below the \`\`\` cell delimiter
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_output_win_max_height = 20
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        -- ... other ts config
        textobjects = {
          move = {
            enable = true,
            set_jumps = false, -- you can change this if you want.
            goto_next_start = {
              --- ... other keymaps
              ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
            },
            goto_previous_start = {
              --- ... other keymaps
              ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
            },
          },
          select = {
            enable = true,
            lookahead = true, -- you can change this if you want
            keymaps = {
              --- ... other keymaps
              ["ib"] = { query = "@code_cell.inner", desc = "in block" },
              ["ab"] = { query = "@code_cell.outer", desc = "around block" },
            },
          },
          swap = { -- Swap only works with code blocks that are under the same
            -- markdown header
            enable = true,
            swap_next = {
              --- ... other keymap
              ["<leader>sbl"] = "@code_cell.outer",
            },
            swap_previous = {
              --- ... other keymap
              ["<leader>sbh"] = "@code_cell.outer",
            },
          },
        }
      })
      vim.keymap.set(
        "n",
        "<localleader>e",
        ":MoltenEvaluateOperator<CR>",
        { desc = "evaluate operator", silent = true }
      )
      vim.keymap.set(
        "n",
        "<localleader>os",
        ":noautocmd MoltenEnterOutput<CR>",
        { desc = "open output window", silent = true }
      )
      vim.keymap.set(
        "n",
        "<localleader>rr",
        ":MoltenReevaluateCell<CR>",
        { desc = "re-eval cell", silent = true }
      )
      vim.keymap.set(
        "v",
        "<localleader>r",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { desc = "execute visual selection", silent = true }
      )
      vim.keymap.set(
        "n",
        "<localleader>oh",
        ":MoltenHideOutput<CR>",
        { desc = "close output window", silent = true }
      )
      vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })

      -- if you work with html outputs:
      vim.keymap.set(
        "n",
        "<localleader>mx",
        ":MoltenOpenInBrowser<CR>",
        { desc = "open output in browser", silent = true }
      )
    end,
  },
  -- plugins/quarto.lua
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "markdown" },
    config = function()
      local quarto = require("quarto")
      quarto.setup({
        lspFeatures = {
          -- NOTE: put whatever languages you want here:
          languages = { "r", "python", "rust" },
          chunks = "all",
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
          },
          completion = {
            enabled = true,
          },
        },
        keymap = {
          -- NOTE: setup your own keymaps:
          hover = "H",
          definition = "gd",
          rename = "<leader>rn",
          references = "gr",
          format = "<leader>gf",
        },
        codeRunner = {
          enabled = true,
          default_method = "molten",
        },
      })
      local runner = require("quarto.runner")
      vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
      vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
      vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
      vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
      vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
      vim.keymap.set("n", "<localleader>RA", function()
        runner.run_all(true)
      end, { desc = "run all cells of all languages", silent = true })
    end,
  },
  {
    "GCBallesteros/jupytext.nvim",
    config = function()
      require("jupytext").setup({
        style = "markdown",
        output_extension = "md",
        force_ft = "markdown",
      })
    end,
  },
}
