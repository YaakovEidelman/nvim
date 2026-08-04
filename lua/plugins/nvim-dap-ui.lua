return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>dt",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug: toggle UI",
      },
    },
    config = function()
      require("dapui").setup()
    end,
  },
}
