return {
    {
        "mason-org/mason.nvim",
        opts = {
            -- Add custom registry for Roslyn LSP
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",  -- Contains roslyn
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "lua_ls",
            },
        },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "mason-org/mason.nvim",
        },
        opts = {
            ensure_installed = {
                -- C# / .NET LSP and tools
                "roslyn",      -- Roslyn C# language server (from custom registry)
                "netcoredbg",  -- .NET debugger (required for DAP)
                "csharpier",   -- C# code formatter

                -- Other useful tools
                "stylua",      -- Lua formatter
            },
            auto_update = false,
            run_on_start = true,
            start_delay = 3000, -- Wait 3 seconds before installing
        },
    },
}
