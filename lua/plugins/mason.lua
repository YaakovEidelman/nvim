return {
	{
		"mason-org/mason.nvim",
		opts = {
            ensure_installed = {
                "black",
                "debugpy",
                "prettier",
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
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
}
