return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.install({
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
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
				callback = function(args)
					local buf = args.buf
					local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
					if not lang then
						return
					end

					if vim.tbl_contains(ts.get_installed(), lang) then
						vim.treesitter.start(buf, lang)
					elseif vim.tbl_contains(ts.get_available(), lang) then
						ts.install(lang):await(function(err)
							if err then
								vim.schedule(function()
									vim.notify(
										("treesitter: failed to install parser for %q: %s"):format(lang, err),
										vim.log.levels.ERROR
									)
								end)
								return
							end
							vim.schedule(function()
								if vim.api.nvim_buf_is_valid(buf) and vim.tbl_contains(ts.get_installed(), lang) then
									vim.treesitter.start(buf, lang)
								end
							end)
						end)
					end
				end,
			})
		end,
	},
}

-- Old config

-- return {
-- 	{
-- 		"nvim-treesitter/nvim-treesitter",
-- 		lazy = false,
-- 		build = ":TSUpdate",
-- 		config = function()
-- 			local ts = require("nvim-treesitter.configs")
-- 			ts.setup({
-- 				modules = {},
-- 				sync_install = false,
-- 				ignore_install = {},
-- 				ensure_installed = {
-- 					"c",
-- 					"cpp",
-- 					"lua",
-- 					"vim",
-- 					"vimdoc",
-- 					"query",
-- 					"markdown",
-- 					"typescript",
-- 					"javascript",
-- 					"tsx",
-- 					"python",
-- 					"rust",
-- 					"html",
-- 					"css",
-- 					"c_sharp",
-- 				},
-- 				auto_install = true,
-- 				highlight = {
-- 					enable = true,
-- 					-- disable = function(lang, buf)
-- 					-- 	local max_filesize = 100 * 1024
-- 					-- 	local ok, stats = pcall((vim.uv or vim.loop)).fs_stat, vim.api.nvim_buf_get_name(buf)
-- 					-- 	if ok and stats and stats.size > max_filesize then
-- 					-- 		return true
-- 					-- 	end
-- 					-- end,
-- 					additional_vim_regex_highlighting = false,
-- 				},
-- 			})
-- 		end,
-- 	},
-- }
