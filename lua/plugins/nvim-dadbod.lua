return {
    {
        "tpope/vim-dadbod",
        lazy = true,
        config = function()
            vim.keymap.set("v", "<leader>eq", "<cmd>DB<CR>")
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
            vim.keymap.set("n", "<leader>sql", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI" })
        end,
    }
}
