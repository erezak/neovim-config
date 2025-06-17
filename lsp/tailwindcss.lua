return {
  "tailwindcss",
  filetypes = { "templ", "html" },
  cmd = { "tailwindcss-language-server", "--stdio" },
  root_markers = { ".git" },
  settings = {
    tailwindCSS = {
      experimental = {
        configFile = "static/css/tailwind.css",
      },
      files = {
        exclude = { ".direnv" },
      },
    },
  },
}
