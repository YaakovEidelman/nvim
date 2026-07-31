return {
  {
    "Weissle/persistent-breakpoints.nvim",
    dependencies = "mfussenegger/nvim-dap",
    event = "BufReadPost",
    keys = {
      {
        "<leader>bp",
        function()
          local pbapi = require("persistent-breakpoints.api")
          pb.toggle_breakpoint()
        end,
        desc = "Debug: toggle breakpoint",
      },
      {
        "<leader>bca",
        function()
          local pbapi = require("persistent-breakpoints.api")
          pb.clear_all_breakpoints()
        end,
        desc = "Debug: clear all breakpoints",
      },
    },
    config = function()
      local pb = require("persistent-breakpoints")
      pb.setup({
        save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
        load_breakpoints_event = "BufReadPost",
        perf_record = false,
        on_load_breakpoint = nil,
        auto_load = true,
        auto_save = true,
      })
      -- vim.keymap.set("n", "<YourKey2>",
      --     "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
    end,
  },
}
