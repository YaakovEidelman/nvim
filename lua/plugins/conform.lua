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
  opts = function()
    local lang = require("lang")
    return {
      formatters = lang.formatter_config(),
      formatters_by_ft = lang.formatters_by_ft(),
    }
  end,
}
