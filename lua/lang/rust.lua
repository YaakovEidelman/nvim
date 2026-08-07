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
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    },
  },
  mason = { "rust-analyzer", "codelldb" },
}
