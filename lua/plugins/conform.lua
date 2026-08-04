return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<M-F>",
      function()
        require("conform").format()
      end,
      desc = "Format: buffer",
    },
  },
  config = function()
    require("conform").setup({
      formatters = {
        csharpier = {
          command = "csharpier",
          args = { "format", "--write-stdout" },
          stdin = true,
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "ruff" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        sh = { "shfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cs = { "csharpier" },
        rust = { "rustfmt" },
      },
    })
  end,
}
