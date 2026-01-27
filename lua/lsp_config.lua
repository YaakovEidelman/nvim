-- Roslyn (C#) is configured via roslyn.nvim plugin - no manual config needed here
local enabled_servers = {
    "ts_ls",
    "pyright",
    "lua_ls",
}

vim.lsp.config("ts_ls", {
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    settings = {},
})

vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = {
        "python",
    },
    settings = {},
})

vim.lsp.config("lua_ls", {
    filetypes = {
        "lua",
    },
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            }
        }
    },
})

vim.lsp.enable(enabled_servers)

-- LSP to show error in code window
vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = {
        prefix = "●",
    },
    float = {
        border = "rounded",
        max_width = 100,
        source = true,
    },
})
