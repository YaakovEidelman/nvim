return {
  {
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup({
        -- log_level = "INFO",
        dap = false, -- registered manually after dap loads to avoid load-order issues
        templates = { "builtin", "vscode_tasks" },
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
      local os_utils = require("utils.os")
      local mason = require("utils.mason")

      local debugpy_python =
        mason.resolve_bin("debugpy", "venv/Scripts/python.exe", "venv/bin/python")
      local netcoredbg_bin =
        mason.resolve_bin("netcoredbg", "netcoredbg/netcoredbg.exe", "netcoredbg")
      local codelldb_bin = mason.resolve_bin(
        "codelldb",
        "extension/adapter/codelldb.exe",
        "extension/adapter/codelldb"
      )

      -- old (test on linux before removing):
      -- local is_windows = vim.fn.has("win32") == 1
      -- local vim_data_path = vim.fn.stdpath("data")
      -- local debugpy_python = vim_data_path .. "/mason/packages/debugpy/venv/bin/python"
      -- local netcoredbg_bin = vim_data_path .. "/mason/packages/netcoredbg/netcoredbg"
      -- local codelldb_bin = vim_data_path:gsub("\\", "/") .. "/mason/packages/codelldb/extension/adapter/codelldb"
      -- if is_windows then
      -- 	debugpy_python = vim_data_path .. "/mason/packages/debugpy/venv/Scripts/python.exe"
      -- 	netcoredbg_bin = netcoredbg_bin .. "/netcoredbg.exe"
      -- 	codelldb_bin = codelldb_bin .. ".exe"
      -- end

      dap.adapters.python = {
        type = "executable",
        command = debugpy_python,
        args = { "-m", "debugpy.adapter" },
        enrich_config = function(config, on_config)
          if not config.pythonPath then
            local venv_python
            if os_utils.is_windows then
              venv_python = vim.fn.getcwd() .. "/.venv/Scripts/python.exe"
            else
              venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
            end
            if vim.fn.executable(venv_python) == 1 then
              config = vim.tbl_extend("force", config, { pythonPath = venv_python })
            end
          end
          on_config(config)
        end,
      }
      dap.adapters.debugpy = dap.adapters.python

      local csharp_common = {
        type = "executable",
        command = netcoredbg_bin,
        args = { "--interpreter=vscode" },
        options = {
          detached = false,
        },
      }
      dap.adapters.coreclr = csharp_common
      dap.adapters.netcoredbg = csharp_common

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_bin,
          args = { "--port", "${port}" },
        },
      }

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
