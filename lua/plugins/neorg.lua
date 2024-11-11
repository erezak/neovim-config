return {
  "nvim-neorg/neorg",
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/notes/general",
            aidev = "~/notes/aidev",
          },
          default_workspace = "notes",
        },
      },
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
      ["core.concealer"] = {
        config = {
          folds = false,
        },
      },
      ["core.integrations.image"] = {},
      ["core.latex.renderer"] = {},
    },
  },
}
