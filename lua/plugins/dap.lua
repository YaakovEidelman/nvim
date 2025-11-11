return {
    {
      'stevearc/overseer.nvim',
      config = function ()
        require("overseer").setup({
          log_level = "TRACE",
        })
      end,
    },
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
            local vscode = require("dap.ext.vscode")

            local function load_vscode_config()
              vscode.load_launchjs()
            end

            load_vscode_config()

            vim.api.nvim_create_autocmd("DirChanged", {
              callback = load_vscode_config,
            })

            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    local current_dir = vim.fn.getcwd()
                    local buffer_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")

                    if current_dir ~= buffer_dir then
                        -- Optional: change the actual Neovim working directory
                        vim.api.nvim_set_current_dir(buffer_dir)

                        load_vscode_config()
                    end
                end,
            })

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
				require("dap").continue()
			end)
			vim.keymap.set("n", "<M-F5>", function()
				require("dap").restart()
			end)
			vim.keymap.set("n", "<C-M-F5>", function()
				require("dap").terminate()
			end)

			vim.keymap.set("n", "<F10>", function()
				require("dap").step_over()
			end)
			vim.keymap.set("n", "<F11>", function()
				require("dap").step_into()
			end)
			vim.keymap.set("n", "<F12>", function()
				require("dap").step_out()
			end)
			vim.keymap.set("n", "<S-F5>", function() end)

			vim.keymap.set("n", "<leader>bp", function()
				require("dap").toggle_breakpoint()
			end)

			vim.keymap.set("n", "<leader>dr", function()
				require("dap").repl.toggle()
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
