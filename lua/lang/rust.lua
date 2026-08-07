return {
  filetypes = { "rust" },
  parsers = { "rust" },
  servers = {
    rust_analyzer = {},
  },
  formatters = {
    rust = { "rustfmt" },
  },
  adapters = {
    codelldb = {
      bin = {
        package = "codelldb",
        win = "extension/adapter/codelldb.exe",
        unix = "extension/adapter/codelldb",
      },
      type = "server",
      port = "${port}",
      executable = {
        command = "${bin}",
        args = { "--port", "${port}" },
      },
    },
  },
  mason = { "rust-analyzer", "codelldb" },
}
