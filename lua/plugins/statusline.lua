return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = 'eldritch',
    },
    sections = {
      lualine_b = {
        {
          function()
            local dir = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':h')
            return dir:gsub(vim.env.HOME, '~')
          end,

          icon = "",
          color = { fg = "#61afef" },
        },
        {
          "filename",
        },
        {
          "branch",
          icon = "",
          color = { fg = "#98c379" },
        },
      },
      lualine_c = {
        {
          function()
            local rec = vim.fn.reg_recording()
            if rec ~= "" then
              return "Recording @" .. rec
            end
            return ""
          end,
          color = { fg = "#ff9e64" },
        },
      },
      lualine_d = {
        {
          "lsp_status",
        },
      },
    },
  },
}
