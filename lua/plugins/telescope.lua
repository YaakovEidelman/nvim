return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local Telescope = require("telescope")
			local actions = require("telescope.actions")
			local builtin = require("telescope.builtin")

			Telescope.setup({
				defaults = {
					preview = {
						treesitter = false,
					},
					mappings = {
						i = {
							["<CR>"] = actions.select_tab,
						},
						n = {
							["<CR>"] = actions.select_tab,
						},
					},
				},
				pickers = {
					buffers = { theme = "ivy" },
					diagnostics = { theme = "ivy" },
					find_files = { theme = "ivy" },
					git_files = { theme = "ivy" },
					help_tags = { theme = "ivy" },
					keymaps = { theme = "ivy" },
					live_grep = { theme = "ivy" },
					lsp_references = { theme = "ivy" },
					lsp_workspace_symbols = { theme = "ivy" },
					symbols = { theme = "ivy" },
				},
				extensions = {
					fzf = {},
				},
			})

			Telescope.load_extension("fzf")
			require("plugins.telescope.multigrep").setup()

			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({
					hidden = true,
				})
			end, { noremap = true })
			vim.keymap.set("n", "<leader>fb", function()
				builtin.buffers()
			end, { noremap = true })
			vim.keymap.set("n", "<leader>fh", function()
				builtin.help_tags()
			end, { noremap = true })
			vim.keymap.set("n", "<leader>bi", function()
				builtin.builtin()
			end, { noremap = true })

			-- vim.keymap.set("n", "<leader>en", function()
			--   builtin.find_files({
			--     cwd = vim.fn.stdpath("config"),
			--   })
			-- end)
			-- vim.keymap.set("n", "<leader>ep", function()
			--   builtin.find_files({
			--     cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
			--   })
			-- end)
		end,
	},
}
