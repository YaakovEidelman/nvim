return {
    {
        "stevearc/overseer.nvim",
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
            local dap_ui_widgets = require("dap.ui.widgets")

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

            local codelldb_bin = vim.fn.stdpath("data"):gsub("\\", "/") .. "/mason/packages/codelldb/extension/adapter/codelldb"
            if vim.fn.has("win32") == 1 then
                codelldb_bin = codelldb_bin .. ".exe"
            end
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb_bin,
                    args = { "--port", "${port}" },
                },
            }

            dap.configurations.c = {
                {
                    name = "Launch",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        local path = vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
                        return path:gsub("\\", "/")
                    end,
                    cwd = vim.fn.getcwd,
                    stopOnEntry = false,
                },
            }

            vim.keymap.set("n", "<leader>da", function()
                dap.run({
                    type = "coreclr",
                    request = "attach",
                    name = "Attach debugger",
                    processId = require("dap.utils").pick_process,
                })
            end)

            vim.api.nvim_set_hl(0, "DapBreakpointColor", { fg = "#FF0000" }) -- , bg = "#3C1010"
            vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#4A4A00" })

            vim.fn.sign_define("DapBreakpoint", {
                text = "●",
                texthl = "DapBreakpointColor",
            })

            vim.fn.sign_define("DapStopped", {
                text = "▶",
                texthl = "DapStopped",
                linehl = "DapStoppedLine",
            })

            vim.keymap.set("n", "<leader>dc", function()
                dap.continue()
            end, { desc = "Debug: start/continue" })
            vim.keymap.set("n", "<leader>dR", function()
                dap.restart()
            end, { desc = "Debug: restart" })
            vim.keymap.set("n", "<leader>dq", function()
                dap.terminate()
            end, { desc = "Debug: stop" })
            vim.keymap.set("n", "<leader>dn", function()
                dap.step_over()
            end, { desc = "Debug: step over" })
            vim.keymap.set("n", "<leader>di", function()
                dap.step_into()
            end, { desc = "Debug: step into" })
            vim.keymap.set("n", "<leader>do", function()
                dap.step_out()
            end, { desc = "Debug: step out" })

            -- vim.keymap.set("n", "<leader>bp", function()
            --     dap.toggle_breakpoint()
            -- end)

            vim.keymap.set("n", "<leader>dr", function()
                dap.repl.toggle()
            end)
            vim.keymap.set({ "n", "v" }, "<leader>dh", function()
                dap_ui_widgets.hover()
            end)
            vim.keymap.set({ "n", "v" }, "<leader>dp", function()
                dap_ui_widgets.preview()
            end)
            vim.keymap.set("n", "<leader>df", function()
                dap_ui_widgets.centered_float(dap_ui_widgets.frames)
            end)
            vim.keymap.set("n", "<leader>ds", function()
                dap_ui_widgets().centered_float(dap_ui_widgets.scopes)
            end)
            vim.keymap.set("n", "<leader>dt", function()
                local widgets = require("dapui")
                widgets.toggle()
            end)
        end,
    },
}
