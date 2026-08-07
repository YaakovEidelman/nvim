return {
  filetypes = { "css", "scss" },
  parsers = { "css" },
  servers = {
    cssls = {
      settings = {
        css = {
          lint = {
            emptyRules = "ignore",
          },
        },
      },
    },
  },
  formatters = {
    css = { "prettier" },
    scss = { "prettier" },
  },
  mason = { "css-lsp", "prettier" },
}
