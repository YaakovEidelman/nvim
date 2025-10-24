return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local Telescope = require("telescope")

      Telescope.setup({
        -- pickers = {
        --   find_files = {
        --     theme = "ivy",
        --   },
        -- },
        extensions = {
          fzf = {},
        },
      })

      Telescope.load_extension("fzf")
      require("plugins.telescope.multigrep").setup()

      -- vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
      -- vim.keymap.set("n", "<leader>bi", ":Telescope builtin<cr>")
      -- vim.keymap.set("n", "<leader>en", function()
      --   require("telescope.builtin").find_files({
      --     cwd = vim.fn.stdpath("config"),
      --   })
      -- end)
      -- vim.keymap.set("n", "<leader>ep", function()
      --   require("telescope.builtin").find_files({
      --     cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
      --   })
      -- end)
    end,
  },
}
