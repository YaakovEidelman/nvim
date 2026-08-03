return {
  {
    "tpope/vim-dadbod",
    cmd = "DB",
    keys = {
      { "<leader>eq", ":DB<CR>", mode = "v", silent = true, desc = "DB: execute selection" },
    },
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    keys = {
      { "<leader>sql", "<cmd>DBUIToggle<cr>", desc = "DB: toggle UI" },
      { "<leader>sf", "<cmd>DBUIFindBuffer<cr>", desc = "DB: connect file to sql buffer" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
    end,
  },
}
