return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")

      config.setup({
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "python",
          "javascript",
          "html",
          "markdown",
          "markdown_inline",
          "zig",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = false },
      })
    end
  },
}
