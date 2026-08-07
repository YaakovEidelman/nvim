return {
  {
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup({
        -- log_level = "INFO",
        dap = false, -- registered manually after dap loads to avoid load-order issues
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapNew", "DapEval", "DapShowLog", "DapClearBreakpoints" },
    keys = {
      { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Debug: start/continue" },
      {
        "<leader>da",
        function()
          require("dap").run({
            type = "coreclr",
            request = "attach",
            name = "Attach debugger",
            processId = require("dap.utils").pick_process,
          })
        end,
        desc = "Debug: attach to process",
      },
      {
        "<leader>dR",
        function()
          require("dap").restart()
        end,
        desc = "Debug: restart",
      },
      { "<leader>dq", "<cmd>DapTerminate<cr>", desc = "Debug: stop" },
      { "<leader>dn", "<cmd>DapStepOver<cr>", desc = "Debug: step over" },
      { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Debug: step into" },
      { "<leader>do", "<cmd>DapStepOut<cr>", desc = "Debug: step out" },
      { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Debug: toggle repl" },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        mode = { "n", "v" },
        desc = "Debug: hover",
      },
      {
        "<leader>dp",
        function()
          require("dap.ui.widgets").preview()
        end,
        mode = { "n", "v" },
        desc = "Debug: preview",
      },
      {
        "<leader>df",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end,
        desc = "Debug: frames",
      },
      {
        "<leader>ds",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Debug: scopes",
      },
    },
    config = function()
      local dap = require("dap")

      for name, adapter in pairs(require("lang").adapters()) do
        dap.adapters[name] = adapter
      end

      -- This is just for reference when creating launch.json files
      -- dap.configurations.c = {
      -- 	{
      -- 		name = "Launch",
      -- 		type = "codelldb",
      -- 		request = "launch",
      -- 		program = function()
      -- 			local path = vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
      -- 			return path:gsub("\\", "/")
      -- 		end,
      -- 		cwd = vim.fn.getcwd,
      -- 		stopOnEntry = false,
      -- 	},
      -- }

      require("utils.highlights").persist("dap", {
        DapBreakpointColor = { fg = "#FF0000" },
        DapStopped = { fg = "#ffe032" },
        DapStoppedLine = { bg = "#3c3800" },
      })

      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DapBreakpointColor",
      })

      vim.fn.sign_define("DapStopped", {
        text = "▶",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
      })

      require("overseer").enable_dap()
    end,
  },
}
