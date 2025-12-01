return {
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local vscode = require("vscode")
			vscode.setup({
				-- optional settings
				transparent = false,
				italic_comments = true,
				disable_nvimtree_bg = true,
				style = "light",
				color_overrides = {
					-- vscFunction = "#FF0000",
					-- vscFront = "#EEAA33",
					-- vscBack = "#00FFFF",
				},
			})
			vscode.load()
		end,
	},
}
