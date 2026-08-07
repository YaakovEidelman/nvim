return {
  filetypes = { "python" },
  parsers = { "python" },
  servers = {
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
  },
  formatters = {
    python = { "black", "ruff" },
  },
  adapters = {
    python = {
      bin = {
        package = "debugpy",
        win = "venv/Scripts/python.exe",
        unix = "venv/bin/python",
      },
      type = "executable",
      command = "${bin}",
      args = { "-m", "debugpy.adapter" },
      enrich_config = function(config, on_config)
        if not config.pythonPath then
          local venv_python
          if require("utils.os").is_windows then
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
    },
    debugpy = "python",
  },
  mason = { "pyright", "black", "ruff", "debugpy" },
}
