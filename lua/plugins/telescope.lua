local os_utils = require("utils.public.os")

return {
  {
    "nvim-telescope/telescope.nvim",
    -- branch = "master",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = os_utils.is_windows
            and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
          or "make",
      },
    },
    config = function()
      local Telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      Telescope.setup({
        defaults = {
          preview = {
            treesitter = false,
          },
          -- mappings = {
          -- 	i = {
          -- 		["<CR>"] = actions.select_tab,
          -- 	},
          -- 	n = {
          -- 		["<CR>"] = actions.select_tab,
          -- 	},
          -- },
        },
        pickers = {
          buffers = { theme = "ivy", previewer = false },
          diagnostics = { theme = "ivy" },
          find_files = { theme = "ivy" },
          git_files = { theme = "ivy" },
          help_tags = { theme = "ivy" },
          keymaps = { theme = "ivy" },
          live_grep = { theme = "ivy" },
          lsp_references = { theme = "ivy" },
          lsp_workspace_symbols = { theme = "ivy" },
          symbols = { theme = "ivy" },
          builtin = { theme = "ivy" },
        },
        extensions = {
          fzf = {},
        },
      })

      if not pcall(Telescope.load_extension, "fzf") then
        local deps = os_utils.is_windows
            and "CMake and a C compiler (e.g. Visual Studio Build Tools)"
          or "make and a C compiler (gcc/clang)"
        vim.schedule(function()
          vim.notify(
            "Telescope: using the built-in Lua sorter. For faster fuzzy matching, install "
              .. deps
              .. ", then run :Lazy build telescope-fzf-native.nvim",
            vim.log.levels.INFO,
            { title = "telescope-fzf-native" }
          )
        end)
      end
      require("utils.multigrep").setup()

      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({
          hidden = true,
        })
      end, { noremap = true })
      vim.keymap.set("n", "<leader>fF", function()
        local root = os_utils.is_windows and "C:\\" or "/"
        builtin.find_files({
          cwd = root,
          hidden = true,
        })
      end, { noremap = true, desc = "Find files from root (global)" })
      vim.keymap.set("n", "<leader>fb", function()
        builtin.buffers()
      end, { noremap = true })
      vim.keymap.set("n", "<leader>fh", function()
        builtin.help_tags()
      end, { noremap = true })
      vim.keymap.set("n", "<leader>bi", function()
        builtin.builtin()
      end, { noremap = true })
      vim.keymap.set("n", "<leader>fd", function()
        builtin.diagnostics()
      end, { noremap = true })
      vim.keymap.set("n", "grr", function()
        builtin.lsp_references()
      end, { noremap = true })
      -- vim.keymap.set("n", "<leader>en", function()
      --   builtin.find_files({
      --     cwd = vim.fn.stdpath("config"),
      --   })
      -- end)
      -- vim.keymap.set("n", "<leader>ep", function()
      --   builtin.find_files({
      --     cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
      --   })
      -- end)
    end,
  },
}
