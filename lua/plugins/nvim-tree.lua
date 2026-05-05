return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({
			view = {
				side = "right",
			},
			filters = {
				dotfiles = false,
			},
		})
	end,
}
