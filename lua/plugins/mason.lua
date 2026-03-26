return {
	{
		"mason-org/mason.nvim",
		opts = {
            ensure_installed = {
                "black",
                "debugpy",
                "prettier",
                "stylua",
                "clang-format",
                "shfmt",
                "csharpier",
            }
        },
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
                "pyright",
				"ts_ls",
                "clangd",
                "rust_analyzer",
                "html",
                "cssls",
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
}
