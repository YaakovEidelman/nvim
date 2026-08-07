return {
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  parsers = { "typescript", "javascript", "tsx" },
  servers = {
    ts_ls = {},
  },
  formatters = {
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
  },
  mason = { "typescript-language-server", "prettier" },
}
