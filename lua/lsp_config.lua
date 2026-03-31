local enabled_servers = {
    -- "vtsls",
    "ts_ls",
    "pyright",
    -- "roslyn",
    "lua_ls",
    "clangd",
    "rust_analyzer",
    "html",
    "cssls",
}
vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities()
})

-- vim.lsp.config("vtsls", {
--     filetypes = {
--         "javascript",
--         "javascriptreact",
--         "typescript",
--         "typescriptreact",
--     },
--     settings = {
--         typescript = {
--             updateImportsOnFileMove = { enabled = "always" },
--             suggest = { completeFunctionCalls = true },
--         },
--         javascript = {
--             updateImportsOnFileMove = { enabled = "always" },
--         },
--     },
-- })

vim.lsp.config("ts_ls", {
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
})

vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = {
        "python",
    },
    settings = {
        python = {
            venvPath = ".",
            venv = ".venv",
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
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

vim.lsp.config("clangd", {
    filetypes = { "c", "cpp" },
})

vim.lsp.config("rust_analyzer", {
    filetypes = { "rust" },
})

vim.lsp.config("html", {
    filetypes = { "html" },
    init_options = {
        provideFormatter = false, -- defer to prettier
    },
})

vim.lsp.config("cssls", {
    filetypes = { "css", "scss", "less" },
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
