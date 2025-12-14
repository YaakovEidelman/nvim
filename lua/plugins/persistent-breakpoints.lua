return {
    {
        "Weissle/persistent-breakpoints.nvim",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            require('dap')
            local pb = require('persistent-breakpoints')
            local pbapi = require('persistent-breakpoints.api')
            pb.setup {
                save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
                load_breakpoints_event = "BufReadPost",
                perf_record = false,
                on_load_breakpoint = nil,
                auto_load = true,
                auto_save = true,
            }

            vim.keymap.set("n", "<leader>bp", function()
                pbapi.toggle_breakpoint()
            end)
            -- vim.keymap.set("n", "<YourKey2>",
            --     "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
            -- vim.keymap.set("n", "<YourKey3>",
            --     "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
            -- vim.keymap.set("n", "<YourKey4>", "<cmd>lua require('persistent-breakpoints.api').set_log_point()<cr>", opts)
        end,
    },
}
