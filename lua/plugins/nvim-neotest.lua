return {
    { "nvim-neotest/nvim-nio" },
    {
        "Issafalcon/neotest-dotnet",
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "Issafalcon/neotest-dotnet",
        },
        config = function()
            local neotest = require("neotest")

            neotest.setup({
                adapters = {
                    require("neotest-dotnet")({
                        -- Extra arguments for dotnet test
                        dotnet_additional_args = {
                            "--verbosity detailed",
                        },
                        -- Discovery mode: "project" discovers all tests in project
                        discovery_root = "project",
                    }),
                },
                -- Output configuration
                output = {
                    enabled = true,
                    open_on_run = "short",
                },
                -- Status signs
                status = {
                    enabled = true,
                    signs = true,
                    virtual_text = true,
                },
                -- Summary window
                summary = {
                    enabled = true,
                    animated = true,
                    expand_errors = true,
                },
            })

            -- Keybindings for test operations
            local keymap_opts = { noremap = true, silent = true }

            -- Run nearest test
            vim.keymap.set("n", "<leader>tn", function()
                neotest.run.run()
            end, vim.tbl_extend("force", keymap_opts, { desc = "Run nearest test" }))

            -- Run current file tests
            vim.keymap.set("n", "<leader>tf", function()
                neotest.run.run(vim.fn.expand("%"))
            end, vim.tbl_extend("force", keymap_opts, { desc = "Run file tests" }))

            -- Run all tests in project
            vim.keymap.set("n", "<leader>ta", function()
                neotest.run.run(vim.fn.getcwd())
            end, vim.tbl_extend("force", keymap_opts, { desc = "Run all tests" }))

            -- Debug nearest test
            vim.keymap.set("n", "<leader>td", function()
                neotest.run.run({ strategy = "dap" })
            end, vim.tbl_extend("force", keymap_opts, { desc = "Debug nearest test" }))

            -- Stop running tests
            vim.keymap.set("n", "<leader>ts", function()
                neotest.run.stop()
            end, vim.tbl_extend("force", keymap_opts, { desc = "Stop tests" }))

            -- Toggle test summary panel
            vim.keymap.set("n", "<leader>tt", function()
                neotest.summary.toggle()
            end, vim.tbl_extend("force", keymap_opts, { desc = "Toggle test summary" }))

            -- Show test output
            vim.keymap.set("n", "<leader>to", function()
                neotest.output.open({ enter = true, auto_close = true })
            end, vim.tbl_extend("force", keymap_opts, { desc = "Show test output" }))

            -- Toggle output panel
            vim.keymap.set("n", "<leader>tp", function()
                neotest.output_panel.toggle()
            end, vim.tbl_extend("force", keymap_opts, { desc = "Toggle output panel" }))

            -- Jump to next/previous failed test
            vim.keymap.set("n", "[t", function()
                neotest.jump.prev({ status = "failed" })
            end, vim.tbl_extend("force", keymap_opts, { desc = "Previous failed test" }))

            vim.keymap.set("n", "]t", function()
                neotest.jump.next({ status = "failed" })
            end, vim.tbl_extend("force", keymap_opts, { desc = "Next failed test" }))

            -- Watch mode (re-run tests on file change)
            vim.keymap.set("n", "<leader>tw", function()
                neotest.watch.toggle(vim.fn.expand("%"))
            end, vim.tbl_extend("force", keymap_opts, { desc = "Toggle watch mode" }))
        end,
    },
}
