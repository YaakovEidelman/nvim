return {
  "seblyng/roslyn.nvim",
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  ft = { "cs", "razor", "csproj", "sln" },
  opts = {
    filewatching = "roslyn",
  },
}
