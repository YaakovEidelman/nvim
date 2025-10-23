-- lua/plugins/ufo.lua
return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    -- The official `nvim-treesitter` now handles fast folding.
    "nvim-treesitter/nvim-treesitter",
    -- `promise-async` is also a dependency for `nvim-ufo`.
    "kevinhwang91/promise-async",
  },
  opts = {
    provider_selector = function(bufnr, ft, filetype_options)
      -- Prioritize LSP-based folds, falling back to Treesitter and then indentation.
      -- return { "lsp", "treesitter", "indent" }
      return { "treesitter" }
    end,
  },
  init = function()
    -- Recommended folding settings for use with nvim-ufo.
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Use the nvim-ufo fold expression.
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "nvim_ufo#fold_expr()"
  end,
}
