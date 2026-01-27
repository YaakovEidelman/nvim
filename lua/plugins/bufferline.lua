return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VimEnter",
	opts = {
		options = {
			mode = "tabs",
			diagnostics = "nvim_lsp",
			show_buffer_close_icons = true,
			show_close_icon = false,
			separator_style = "slant",
			always_show_bufferline = true,
		},
	},
}
