return {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	opts = {
		on_attach = function(bufnr)
			local gs = require("gitsigns")
			local map = function(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gs.nav_hunk("next")
				end
			end, "Next hunk")

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gs.nav_hunk("prev")
				end
			end, "Prev hunk")

			map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
			map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
			map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
			map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle line blame")
		end,
	},
}
