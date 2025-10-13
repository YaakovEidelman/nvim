return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      -- hrsh7th/nvim-cmp is required for cmp-nvim-lsp to function
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        require("cmp_nvim_lsp").default_capabilities()
      )

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


      vim.lsp.enable("ts_ls")
      vim.lsp.enable("pyright")

      -- Configure nvim-cmp with the nvim_lsp source
      local cmp = require("cmp")
      cmp.setup({
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
  }
}
