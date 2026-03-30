return {
	{
		"echasnovski/mini.nvim",
		config = function()
			local statusline = require("mini.statusline")
            local pairs = require("mini.pairs")

			statusline.setup({
				use_icons = true,
				content = {
					active = function()
						local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
						local git = statusline.section_git({ trunc_width = 40 })
						local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
						local lsp = (function()
							if statusline.is_truncated(75) then
								return ""
							end
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							if #clients == 0 then
								return ""
							end
							local names = vim.tbl_map(function(c)
								return c.name
							end, clients)
							return "󰰎 " .. table.concat(names, ", ")
						end)()
						local filename = vim.bo.buftype == "terminal" and "%t" or "%F%{&modified?'*':''}%r"
						local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
						local location = statusline.is_truncated(75) and "Ln %l│Col %v" or "Ln %l|Col %v"

						return statusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
							{ hl = "MiniStatuslineFileinfo", strings = { lsp } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=", -- End left alignment
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = mode_hl, strings = { location } },
						})
					end,
				},
			})

            pairs.setup({})
		end,
	},
}
