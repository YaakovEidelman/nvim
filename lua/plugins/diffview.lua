return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
		{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
	},
	opts = {},
}
