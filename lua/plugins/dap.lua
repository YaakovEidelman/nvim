return {
	{
		"stevearc/overseer.nvim",
		config = function()
			require("overseer").setup({
				-- log_level = "INFO",
				dap = false, -- registered manually after dap loads to avoid load-order issues
				templates = { "builtin", "vscode_tasks" },
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local dap_ui_widgets = require("dap.ui.widgets")

			local is_windows = vim.fn.has("win32") == 1
			local vim_data_path = vim.fn.stdpath("data")

			local debugpy_python = vim_data_path .. "/mason/packages/debugpy/venv/bin/python"
			local netcoredbg_bin = vim_data_path .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg"
			local codelldb_bin = vim_data_path:gsub("\\", "/") .. "/mason/packages/codelldb/extension/adapter/codelldb"
			if is_windows then
				debugpy_python = vim_data_path .. "/mason/packages/debugpy/venv/Scripts/python.exe"
				netcoredbg_bin = netcoredbg_bin .. ".exe"
				codelldb_bin = codelldb_bin .. ".exe"
			end

			dap.adapters.python = {
				type = "executable",
				command = debugpy_python,
				args = { "-m", "debugpy.adapter" },
				enrich_config = function(config, on_config)
					if not config.pythonPath then
						local venv_python
						if is_windows then
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

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_bin,
					args = { "--port", "${port}" },
				},
			}

			-- dap.configurations.c = {
			-- 	{
			-- 		name = "Launch",
			-- 		type = "codelldb",
			-- 		request = "launch",
			-- 		program = function()
			-- 			local path = vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
			-- 			return path:gsub("\\", "/")
			-- 		end,
			-- 		cwd = vim.fn.getcwd,
			-- 		stopOnEntry = false,
			-- 	},
			-- }

			vim.keymap.set("n", "<leader>da", function()
				dap.run({
					type = "coreclr",
					request = "attach",
					name = "Attach debugger",
					processId = require("dap.utils").pick_process,
				})
			end)

			vim.api.nvim_set_hl(0, "DapBreakpointColor", { fg = "#FF0000" }) -- , bg = "#3C1010"
			vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#ffe032", blend = 60 })

			vim.fn.sign_define("DapBreakpoint", {
				text = "●",
				texthl = "DapBreakpointColor",
			})

			vim.fn.sign_define("DapStopped", {
				text = "▶",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
			})

			local keymaps = {
				{ mode = "n", lhs = "<leader>dc", rhs = dap.continue, desc = "Debug: start/continue" },
				{ mode = "n", lhs = "<leader>dR", rhs = dap.restart, desc = "Debug: restart" },
				{ mode = "n", lhs = "<leader>dq", rhs = dap.terminate, desc = "Debug: stop" },
				{ mode = "n", lhs = "<leader>dn", rhs = dap.step_over, desc = "Debug: step over" },
				{ mode = "n", lhs = "<leader>di", rhs = dap.step_into, desc = "Debug: step into" },
				{ mode = "n", lhs = "<leader>do", rhs = dap.step_out, desc = "Debug: step out" },
				{ mode = "n", lhs = "<leader>dr", rhs = dap.repl.toggle, desc = "Debug: toggle repl" },
				{ mode = { "n", "v" }, lhs = "<leader>dh", rhs = dap_ui_widgets.hover, desc = "Debug: hover" },
				{ mode = { "n", "v" }, lhs = "<leader>dp", rhs = dap_ui_widgets.preview, desc = "Debug: preview" },
				{
					mode = "n",
					lhs = "<leader>df",
					rhs = function()
						dap_ui_widgets.centered_float(dap_ui_widgets.frames)
					end,
					desc = "Debug: frames",
				},
				{
					mode = "n",
					lhs = "<leader>ds",
					rhs = function()
						dap_ui_widgets.centered_float(dap_ui_widgets.scopes)
					end,
					desc = "Debug: scopes",
				},
				{
					mode = "n",
					lhs = "<leader>dt",
					rhs = function()
						require("dapui").toggle()
					end,
					desc = "Debug: toggle UI",
				},
			}

			for _, m in ipairs(keymaps) do
				vim.keymap.set(m.mode, m.lhs, m.rhs, { desc = m.desc })
			end

			require("overseer").enable_dap()

			-- vim.keymap.set("n", "<leader>dc", function()
			--     dap.continue()
			-- end, { desc = "Debug: start/continue" })
			-- vim.keymap.set("n", "<leader>dR", function()
			--     dap.restart()
			-- end, { desc = "Debug: restart" })
			-- vim.keymap.set("n", "<leader>dq", function()
			--     dap.terminate()
			-- end, { desc = "Debug: stop" })
			-- vim.keymap.set("n", "<leader>dn", function()
			--     dap.step_over()
			-- end, { desc = "Debug: step over" })
			-- vim.keymap.set("n", "<leader>di", function()
			--     dap.step_into()
			-- end, { desc = "Debug: step into" })
			-- vim.keymap.set("n", "<leader>do", function()
			--     dap.step_out()
			-- end, { desc = "Debug: step out" })

			-- <leader>bp is set in persisten breakpoints plugin
			-- vim.keymap.set("n", "<leader>bp", function()
			--     dap.toggle_breakpoint()
			-- end)

			-- vim.keymap.set("n", "<leader>dr", function()
			--     dap.repl.toggle()
			-- end)
			-- vim.keymap.set({ "n", "v" }, "<leader>dh", function()
			--     dap_ui_widgets.hover()
			-- end)
			-- vim.keymap.set({ "n", "v" }, "<leader>dp", function()
			--     dap_ui_widgets.preview()
			-- end)
			-- vim.keymap.set("n", "<leader>df", function()
			--     dap_ui_widgets.centered_float(dap_ui_widgets.frames)
			-- end)
			-- vim.keymap.set("n", "<leader>ds", function()
			--     dap_ui_widgets.centered_float(dap_ui_widgets.scopes)
			-- end)
			-- vim.keymap.set("n", "<leader>dt", function()
			--     local widgets = require("dapui")
			--     widgets.toggle()
			-- end)
		end,
	},
}
