return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	config = function()
		require("conform").setup({
			-- format_on_save = {
			--   timeout_ms = 2000,
			--   lsp_fallback = true,
			-- },
			-- format_on_save = {
			--              timeout_ms = 250,
			--              lsp_fallback = true,
			--          },
			format_on_save = false,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black", "ruff" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				javascriptreact = { "prettier" },
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
