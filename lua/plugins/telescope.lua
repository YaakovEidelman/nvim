local os_utils = require("utils.public.os")

return {
  {
    "nvim-telescope/telescope.nvim",
    -- branch = "master",
    version = "*",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find: files" },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({
            cwd = os_utils.is_windows and "C:\\" or "/",
            hidden = true,
          })
        end,
        desc = "Find: files from filesystem root",
      },
      {
        "<leader>fg",
        function()
          require("utils.multigrep").live_multigrep()
        end,
        desc = "Find: grep (pattern<space><space>glob)",
      },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find: buffers" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Find: diagnostics" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find: help tags" },
      { "<leader>bi", "<cmd>Telescope builtin<cr>", desc = "Find: telescope pickers" },
      { "grr", "<cmd>Telescope lsp_references<cr>", desc = "Find: LSP references" },
    },
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

      Telescope.setup({
        defaults = {
          preview = {
            treesitter = false,
          },
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
    end,
  },
}
