return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				direction = "float",
				start_in_insert = true,
				close_on_exit = true,
				float_opts = {
					border = "single",
					width = function()
						return math.floor(vim.o.columns * 0.85)
					end,
					height = function()
						return math.floor(vim.o.lines * 0.8)
					end,
				},
				winbar = { enabled = false },
			})

			local current_term = 1

			-- Build tab string
			local function build_tabline()
				local tabs = {}
				for i = 1, 9 do
					if i == current_term then
						table.insert(tabs, "[" .. i .. "]")
					else
						table.insert(tabs, " " .. i .. " ")
					end
				end
				return table.concat(tabs, "")
			end

			-- Apply winbar to current window
			local function update_winbar()
				pcall(vim.api.nvim_set_option_value, "winbar", build_tabline(), { win = 0 })
			end

			-- Open a specific terminal (and close others)
			local function open_term(n)
				-- close all visible terminals
				vim.cmd("ToggleTermToggleAll")

				current_term = n
				vim.cmd("ToggleTerm " .. n)

				vim.defer_fn(update_winbar, 10)
			end

			-- Toggle current terminal
			local function toggle_current()
				vim.cmd("ToggleTerm " .. current_term)
				vim.defer_fn(update_winbar, 10)
			end

			-- Cycle forward
			local function next_term()
				current_term = (current_term % 9) + 1
				open_term(current_term)
			end

			-- Cycle backward
			local function prev_term()
				current_term = current_term == 1 and 9 or current_term - 1
				open_term(current_term)
			end

			-- Keymaps
			local opts = { noremap = true, silent = true }

			vim.keymap.set("n", "<leader>ot", toggle_current, opts)

			for i = 1, 9 do
				vim.keymap.set("n", "<leader>o" .. i, function()
					open_term(i)
				end, opts)

				vim.keymap.set("t", "<leader>o" .. i, function()
					open_term(i)
				end, opts)
			end

			vim.keymap.set("t", "<C-Tab>", next_term, opts)
			vim.keymap.set("t", "<C-S-Tab>", prev_term, opts)

			-- Window navigation from terminal
			vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
			vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
			vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
			vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
		end,
	},
}
