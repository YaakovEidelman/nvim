return {
  filetypes = { "html" },
  parsers = { "html" },
  servers = {
    html = {
      init_options = {
        provideFormatter = false, -- defer to prettier
      },
    },
  },
  formatters = {
    html = { "prettier" },
  },
  mason = { "html-lsp", "prettier" },
}
