local enabled_servers = {
    "vtsls",
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

vim.lsp.config("vtsls", {
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    settings = {
        typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
        },
        javascript = {
            updateImportsOnFileMove = { enabled = "always" },
        },
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

-- vim.lsp.config("roslyn", {
--     cmd = {
--         "dotnet",
--         "/home/yaakov/.local/share/roslyn-lsp/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll",
--         "--logLevel",
--         "Information",
--         "--extensionLogDirectory",
--         "/home/yaakov/Desktop",
--         "--stdio",
--     },
--     filetypes = {
--         "cs",
--         "csproj",
--         "sln",
--     },
--     settings = {
--         ["csharp|inlay_hints"] = {
--             csharp_enable_inlay_hints_for_implicit_object_creation = true,
--             csharp_enable_inlay_hints_for_implicit_variable_types = true,
--         },
--         ["csharp|code_lens"] = {
--             dotnet_enable_references_code_lens = true,
--         },
--     },
-- })

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
