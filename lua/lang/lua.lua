return {
  filetypes = { "lua" },
  parsers = { "lua" },
  servers = {
    lua_ls = {},
  },
  formatters = {
    lua = { "stylua" },
  },
  mason = { "lua-language-server", "stylua" },
}
