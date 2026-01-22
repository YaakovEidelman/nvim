return {
    {
        "mason-org/mason.nvim",
        opts = {},
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
                -- C# / .NET debugging and formatting
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
