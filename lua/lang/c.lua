return {
  filetypes = { "c", "cpp" },
  parsers = { "c", "cpp" },
  servers = {
    clangd = {},
  },
  formatters = {
    c = { "clang_format" },
    cpp = { "clang_format" },
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
  mason = { "clangd", "clang-format", "codelldb" },
}
