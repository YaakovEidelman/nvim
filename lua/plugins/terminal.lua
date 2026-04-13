return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
            local toggleterm = require("toggleterm")
			toggleterm.setup({
				direction = "horizontal",
				start_in_insert = true,
				close_on_exit = true,
				size = function()
					return math.floor(vim.o.lines * 0.25)
				end,
				winbar = { enabled = false },
			})

            local opts = { noremap = true, silent = true }

			for i = 0, 9 do
				vim.keymap.set("n", "<leader>o" .. i, "<cmd>ToggleTerm " .. i .. "<cr>", opts)
				vim.keymap.set("t", "<leader>o" .. i, "<cmd>ToggleTerm " .. i .. "<cr>", opts)
			end

			vim.keymap.set("n", "<leader>ot", function()
				-- vim.cmd("ToggleTerm")
                toggleterm.toggle()
			end, opts)

		end,
	},
}
