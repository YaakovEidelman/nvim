return {
    {
        "stevearc/overseer.nvim",
        config = function()
            require("overseer").setup({})
        end,
    },
    {
        "NicholasMata/nvim-dap-cs",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        opts = function()
            local platform = require("utils.platform")
            local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/"
            local netcoredbg_path

            if platform.is_windows then
                netcoredbg_path = mason_path .. "netcoredbg\\netcoredbg.exe"
            else
                netcoredbg_path = mason_path .. "netcoredbg"
            end

            return {
                netcoredbg = {
                    path = netcoredbg_path,
                },
            }
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local platform = require("utils.platform")

            -- WINDOWS FIX: Convert forward slashes to backslashes for netcoredbg
            if platform.is_windows then
                -- Normalize buffer names to use backslashes when C# files are opened
                vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                    pattern = { "*.cs", "*.csproj", "*.sln" },
                    callback = function(args)
                        local bufname = vim.api.nvim_buf_get_name(args.buf)
                        if bufname and bufname:find("/") then
                            local win_path = platform.normalize_path(bufname)
                            vim.api.nvim_buf_set_name(args.buf, win_path)
                        end
                    end,
                })

                -- Also fix paths when session sends requests (belt and suspenders)
                dap.listeners.before["event_initialized"]["windows_path_fix"] = function(session)
                    local orig_request = session.request
                    session.request = function(self, command, args, callback)
                        if command == "setBreakpoints" and args and args.source and args.source.path then
                            args.source.path = platform.normalize_path(args.source.path)
                        end
                        return orig_request(self, command, args, callback)
                    end
                end
            end

            -- Attach debugger keymap
            vim.keymap.set("n", "<leader>da", function()
                require("dap").run({
                    type = "coreclr",
                    request = "attach",
                    name = "Attach debugger",
                    processId = require("dap.utils").pick_process,
                })
            end)

            -- VS Code Light theme debug colors
            vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#E51400" })
            vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#F48771" })
            vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#848484" })
            vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#F2AB46" })
            vim.api.nvim_set_hl(0, "DapStopped", { fg = "#007ACC" })
            vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#ffe100" })

            vim.fn.sign_define("DapBreakpoint", {
                text = "⬤", -- 🛑 -- ●               
                texthl = "DapBreakpoint",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapBreakpointCondition", {
                text = "◐",
                texthl = "DapBreakpointCondition",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapBreakpointRejected", {
                text = "○",
                texthl = "DapBreakpointRejected",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapLogPoint", {
                text = "◆",
                texthl = "DapLogPoint",
                linehl = "",
                numhl = "",
            })

            vim.fn.sign_define("DapStopped", {
                text = "▶",
                texthl = "DapStopped",
                linehl = "DapStoppedLine",
                numhl = "DapStopped",
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
