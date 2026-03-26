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

            local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
            if vim.fn.has("win32") == 1 then
                debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python.exe"
            end
            dap.adapters.python = {
                type = "executable",
                command = debugpy_python,
                args = { "-m", "debugpy.adapter" },
                enrich_config = function(config, on_config)
                    if not config.pythonPath then
                        local venv_python
                        if vim.fn.has("win32") == 1 then
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
            }
            dap.adapters.debugpy = dap.adapters.python

            local netcoredbg_bin = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg"
            if vim.fn.has("win32") == 1 then
                netcoredbg_bin = netcoredbg_bin .. ".exe"
            end
            dap.adapters.coreclr = {
                type = "executable",
                command = netcoredbg_bin,
                args = { "--interpreter=vscode" },
            }
            dap.adapters.netcoredbg = {
                type = "executable",
                command = netcoredbg_bin,
                args = { "--interpreter=vscode" },
            }

            vim.keymap.set("n", "<leader>da", function()
                require('dap').run({
                    type = "coreclr",
                    request = "attach",
                    name = "Attach debugger",
                    processId = require("dap.utils").pick_process
                })
            end)

            vim.api.nvim_set_hl(0, "DapBreakpointColor", { fg = "#FF0000" }) -- , bg = "#3C1010"
            vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#4A4A00" })

            vim.fn.sign_define("DapBreakpoint", {
                text = "●", -- ●🛑
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
            vim.keymap.set("n", "<leader>dt", function()
                local widgets = require("dapui")
                widgets.toggle()
            end)
        end,
    },
}
