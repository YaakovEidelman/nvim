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
  mason = { "clangd", "clang-format", "codelldb" },
}
