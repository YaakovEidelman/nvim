-- The C# server is roslyn.nvim, configured in lua/plugins/roslyn.lua, so there
-- is no `servers` entry here.
return {
  filetypes = { "cs" },
  parsers = { "c_sharp" },
  formatters = {
    cs = { "csharpier" },
  },
  formatter_config = {
    csharpier = {
      command = "csharpier",
      args = { "format", "--write-stdout" },
      stdin = true,
    },
  },
  adapters = {
    coreclr = {
      bin = {
        package = "netcoredbg",
        win = "netcoredbg/netcoredbg.exe",
        unix = "netcoredbg",
      },
      type = "executable",
      command = "${bin}",
      args = { "--interpreter=vscode" },
      options = {
        detached = false,
      },
    },
    netcoredbg = "coreclr",
  },
  mason = { "roslyn", "csharpier", "netcoredbg" },
}
