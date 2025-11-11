return {
	{
		"numToStr/Comment.nvim",
		opts = {
			-- Your Comment.nvim options here
		},
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		config = function()
			require("ts_context_commentstring").setup({
				-- Your configuration options here
			})
		end,
	},
}
