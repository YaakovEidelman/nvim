return {
	{
		"nvim-treesitter/nvim-treesitter",
		enabled = true,
		lazy = false,
		branch = "master",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter.configs")
			ts.setup({
				modules = {},
				sync_install = false,
				ignore_install = {},
				ensure_installed = {
					"c",
					"cpp",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"typescript",
					"javascript",
					"tsx",
					"python",
					"rust",
					"html",
					"css",
					"c_sharp",
				},
				auto_install = true,
				highlight = {
					enable = true,
					-- disable = function(lang, buf)
					-- 	local max_filesize = 100 * 1024
					-- 	local ok, stats = pcall((vim.uv or vim.loop)).fs_stat, vim.api.nvim_buf_get_name(buf)
					-- 	if ok and stats and stats.size > max_filesize then
					-- 		return true
					-- 	end
					-- end,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}
