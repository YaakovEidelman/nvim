return {
    {
        "tpope/vim-dadbod",
        lazy = true,
        config = function()
            vim.keymap.set("v", "<leader>eq", ":DB<CR>", { silent = true, desc = "Execute Selection" })
        end
    },
    {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql', 'plsql' },
        lazy = true
    },
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
             'tpope/vim-dadbod',
             "kristijanhusak/vim-dadbod-completion",
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_execute_on_save = 0
            vim.keymap.set("n", "<leader>sql", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI" })
            vim.keymap.set("n", "<leader>sf", "<cmd>DBUIFindBuffer<CR>", { desc = "Connect open file to sql buffer" })
        end,
    }
}
