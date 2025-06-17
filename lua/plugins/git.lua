return {
  {
    "lewis6991/gitsigns.nvim",
    config = true,
    lazy = false,
    keys = {
      { "]c", "<cmd>Gitsigns next_hunk<CR>", desc = "Next Hunk" },
      { "[c", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev Hunk" },
      { "<leader>gh", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
      { "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "Blame Line" },
      { "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "Diff This" },
      { "<leader>gD", "<cmd>Gitsigns diffthis HEAD<CR>", desc = "Diff This HEAD" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
      { "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",

      -- picker
      "folke/snacks.nvim",
    },
    keys = {
      { "<leader>gs", "<cmd>Neogit<CR>", desc = "Neogit" },
      { "<leader>gS", "<cmd>Neogit kind=split<CR>", desc = "Neogit Split" },
      { "<leader>gV", "<cmd>Neogit kind=vsplit<CR>", desc = "Neogit VSplit" },
      { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Neogit Commit" },
      { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Neogit Pull" },
      { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Neogit Push" },
      { "<leader>gB", "<cmd>:lua Snacks.picker.git_branches()<CR>", desc="Git Branches" },
    },
  },
}
