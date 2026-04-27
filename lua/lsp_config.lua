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
local ok, blink = pcall(require, 'blink.cmp')
vim.lsp.config('*', {
    capabilities = ok and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities(),
    on_attach = function(client, bufnr)
        if client:supports_method('textDocument/inlayHint') then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        if client:supports_method('textDocument/documentHighlight') then
            local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
            vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = bufnr,
                group = group,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = bufnr,
                group = group,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
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
