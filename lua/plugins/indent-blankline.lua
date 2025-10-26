return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		-- enabled = false,
		config = function()
			require("ibl").setup({
				indent = {
					-- This links the rainbow highlight groups to the indent lines.
					highlight = {
						"RainbowDelimiterRed",
						"RainbowDelimiterYellow",
						"RainbowDelimiterBlue",
						"RainbowDelimiterOrange",
						"RainbowDelimiterGreen",
						"RainbowDelimiterViolet",
						"RainbowDelimiterCyan",
					},
				},
				-- Enable this to use Treesitter, required for nvim-ts-rainbow integration.
				scope = {
					enabled = true,
				},
			})
		end,
	},
}
