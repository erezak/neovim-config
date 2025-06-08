return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = {
        "markdown",
        "Avante",
      },
      win_options = {
        conceallevel = { default = vim.o.conceallevel, rendered = vim.o.conceallevel },
        concealcursor = { default = vim.o.concealcursor, rendered = "" },
      },
      heading = {
        border = "true",
      },
      dash = {
        icon = "█",
      },
      indent = {
        enabled = true,
      },
      checkbox = {
        enable = false,
        unchecked = {
          icon = " ",
        },
        checked = {
          icon = "󰱒",
          scope_highlight = "@markup.strikethrough",
        },
        custom = {
          todo = {
            rendered = "◯ ",
          },
          important = {
            raw = "[~]",
            rendered = "󰓎 ",
            highlight = "DiagnosticWarn",
          },
        },
      },
    },
  },
}
