return {
  -- vtsls = {
  --   filetypes = {
  --     "javascript",
  --     "javascriptreact",
  --     "typescript",
  --     "typescriptreact",
  --   },
  --   settings = {
  --     typescript = {
  --       updateImportsOnFileMove = { enabled = "always" },
  --       suggest = { completeFunctionCalls = true },
  --     },
  --     javascript = {
  --       updateImportsOnFileMove = { enabled = "always" },
  --     },
  --   },
  -- },
  ts_ls = {},
  pyright = {
    settings = {
      python = {
        venvPath = ".",
        venv = ".venv",
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  lua_ls = {},
  clangd = {},
  rust_analyzer = {},
  html = {
    init_options = {
      provideFormatter = false, -- defer to prettier
    },
  },
  cssls = {
    settings = {
      css = {
        lint = {
          emptyRules = "ignore",
        },
      },
    },
  },
  postgres_lsp = {},
}
