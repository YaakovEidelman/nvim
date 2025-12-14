return {
    {
        'stevearc/overseer.nvim',
        config = function()
            require("overseer").setup({
                -- log_level = "INFO",
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            dap.adapters.debugpy = {
                type = "executable",
                command = "/home/yaakov/virtual-envs/main-venv/bin/python",
                args = { "-m", "debugpy.adapter" },
                cwd = "/home/yaakov/repos/python/",
            }

            dap.adapters.coreclr = {
                type = "executable",
                command = "netcoredbg",
                args = { "--interpreter=vscode" },
            }

            vim.api.nvim_set_hl(0, "DapBreakpointColor", { fg = "#FF0000" }) -- , bg = "#3C1010"
            vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#4A4A00" })

            vim.fn.sign_define("DapBreakpoint", {
                text = "🛑", -- ●
                texthl = "DapBreakpointColor",
            })

            vim.fn.sign_define("DapStopped", {
                text = "▶",
                texthl = "DapStopped",
                linehl = "DapStoppedLine",
            })

            vim.keymap.set("n", "<F5>", function()
                dap.continue()
            end)
            vim.keymap.set("n", "<M-F5>", function()
                dap.restart()
            end)
            vim.keymap.set("n", "<C-M-F5>", function()
                dap.terminate()
            end)

            vim.keymap.set("n", "<F10>", function()
                dap.step_over()
            end)
            vim.keymap.set("n", "<F11>", function()
                dap.step_into()
            end)
            vim.keymap.set("n", "<F12>", function()
                dap.step_out()
            end)
            vim.keymap.set("n", "<S-F5>", function() end)

            -- vim.keymap.set("n", "<leader>bp", function()
            --     dap.toggle_breakpoint()
            -- end)

            vim.keymap.set("n", "<leader>dr", function()
                dap.repl.toggle()
            end)
            vim.keymap.set({ "n", "v" }, "<leader>dh", function()
                require("dap.ui.widgets").hover()
            end)
            vim.keymap.set({ "n", "v" }, "<leader>dp", function()
                require("dap.ui.widgets").preview()
            end)
            vim.keymap.set("n", "<leader>df", function()
                local widgets = require("dap.ui.widgets")
                widgets.centered_float(widgets.frames)
            end)
            vim.keymap.set("n", "<leader>ds", function()
                local widgets = require("dap.ui.widgets")
                widgets.centered_float(widgets.scopes)
            end)
        end,
    },
}
