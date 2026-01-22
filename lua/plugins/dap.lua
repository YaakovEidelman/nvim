return {
    {
        "stevearc/overseer.nvim",
        config = function()
            require("overseer").setup({})
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            -- Helper function to get the correct netcoredbg path (cross-platform)
            local function get_netcoredbg_path()
                local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/"
                if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
                    -- On Windows, Mason installs in a subdirectory: netcoredbg/netcoredbg/netcoredbg.exe
                    return mason_path .. "netcoredbg/netcoredbg.exe"
                else
                    return mason_path .. "netcoredbg"
                end
            end

            -- .NET / C# debugger configuration
            dap.adapters.coreclr = {
                type = "executable",
                command = get_netcoredbg_path(),
                args = { "--interpreter=vscode" },
            }
            dap.adapters.netcoredbg = dap.adapters.coreclr

            local dotnet = require("config.nvim-dap-dotnet")

            -- Function to build and then get the DLL path
            local function build_and_get_dll()
                local project_root = dotnet.find_project_root_by_csproj(vim.fn.expand("%:p:h"))
                if not project_root then
                    vim.notify("Could not find .csproj file", vim.log.levels.ERROR)
                    return nil
                end

                -- Build the project first
                vim.notify("Building project...", vim.log.levels.INFO)
                local build_cmd = "dotnet build " .. vim.fn.shellescape(project_root)
                local result = vim.fn.system(build_cmd)
                local exit_code = vim.v.shell_error

                if exit_code ~= 0 then
                    vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
                    return nil
                end

                vim.notify("Build succeeded!", vim.log.levels.INFO)
                return dotnet.build_dll_path()
            end

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "Launch (build first)",
                    request = "launch",
                    program = build_and_get_dll,
                },
                {
                    type = "coreclr",
                    name = "Launch (no build)",
                    request = "launch",
                    program = function()
                        return dotnet.build_dll_path()
                    end,
                },
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
            vim.keymap.set("n", "<leader>dt", function()
                local widgets = require("dapui")
                widgets.toggle()
            end)
        end,
    },
}
