return {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor", "csproj", "sln" },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        filewatching = "roslyn",
        -- Settings passed to the Roslyn language server
        settings = {
            ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_parameters = true,
            },
            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
                dotnet_enable_tests_code_lens = true,
            },
            ["csharp|completion"] = {
                dotnet_show_completion_items_from_unimported_namespaces = true,
                dotnet_show_name_completion_suggestions = true,
            },
        },
    },
    config = function(_, opts)
        require("roslyn").setup(opts)
        -- Display a message when Roslyn needs to be installed
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "cs", "razor" },
            once = true,
            callback = function()
                vim.defer_fn(function()
                    local roslyn_path = vim.fn.stdpath("data") .. "/roslyn"
                    if vim.fn.isdirectory(roslyn_path) == 0 then
                        vim.notify(
                            "Roslyn LSP not installed. Run :Roslyn install to install it.",
                            vim.log.levels.WARN
                        )
                    end
                end, 1000)
            end,
        })
    end,
}
