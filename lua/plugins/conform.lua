return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	config = function()
		require("conform").setup({
			formatters = {
				csharpier = {
					command = "csharpier",
					args = { "format", "--write-stdout" },
					stdin = true,
				},
			},
			-- format_on_save = {
			--   timeout_ms = 2000,
			--   lsp_fallback = true,
			-- },
			format_on_save = function()
				return nil
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black", "ruff" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				javascriptreact = { "prettier" },
                json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				sh = { "shfmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				cs = { "csharpier" },
				rust = { "rustfmt" },
			},
		})
	end,
}
