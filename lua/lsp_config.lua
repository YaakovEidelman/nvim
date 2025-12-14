local enabled_servers = {
    "ts_ls",
    "pyright",
    "roslyn",
    "lua_ls",
}
-- local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = vim.tbl_deep_extend("force", capabilities, lsp_capabilities)

vim.lsp.config("ts_ls", {
    -- capabilities = capabilities,
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    settings = {},
})

vim.lsp.config("pyright", {
    -- capabilities = capabilities,
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = {
        "python",
    },
    settings = {},
})

vim.lsp.config("roslyn", {
    -- capabilities = capabilities,
    cmd = {
        "dotnet",
        "/home/yaakov/.local/share/roslyn-lsp/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll",
        "--logLevel",
        "Information",
        "--extensionLogDirectory",
        "/home/yaakov/Desktop",
        "--stdio",
    },
    filetypes = {
        "cs",
        "csproj",
        "sln",
    },
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
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

vim.lsp.enable(enabled_servers)

-- LSP to show error in code window
vim.diagnostic.config({
    virtual_lines = true,
    virtual_text = {

        prefix = "●",
    },
})
