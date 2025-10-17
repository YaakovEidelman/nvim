return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
        settings = {},
      })

      vim.lsp.config("pyright", {
        capabilities = capabilities,
        filetypes = {
          "python",
        },
        settings = {},
      })

      -- local omnisharp_run = vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp"
      -- vim.lsp.config("omnisharp", {
      --   capabilities = capabilities,
      --   cmd = { omnisharp_run },
      --   filetypes = {
      --     "cs",
      --     "csproj",
      --     "sln",
      --   },
      --   settings = {},
      -- })
      --
      vim.lsp.config("roslyn", {
        capabilities = capabilities,
        cmd = {
          "dotnet",
          "/home/yaakov/.local/share/roslyn-lsp/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll",
          "--logLevel",
          "Information",
          "--extensionLogDirectory",
          "/home/yaakov/Desktop",
          "--stdio",
        },
        filetypes = {
          "cs",
          "csproj",
          "sln",
        },
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })

      vim.lsp.enable("ts_ls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("roslyn")
      -- vim.lsp.enable("omnisharp")

      -- Configure nvim-cmp with the nvim_lsp source
      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<cr>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
        },
      })

      -- The following function is for auto-format on save.
      -- vim.api.nvim_create_autocmd('LspAttach', {
      --   callback = function(args)
      --     local client = vim.lsp.get_client_by_id(args.data.client_id)
      --     if not client then return end
      --
      --     if client.supports_method('textDocument/formatting') then
      --       vim.api.nvim_create_autocmd('BufWritePre', {
      --         buffer = args.buf,
      --         callback = function()
      --           vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
      --         end,
      --       })
      --     end
      --   end,
      -- })
    end,
  },
}
