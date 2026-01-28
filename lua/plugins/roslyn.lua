return {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor", "csproj", "sln" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "mason-org/mason.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = {
        -- cmd is auto-configured when roslyn is installed via Mason
        filewatching = "roslyn",
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
}
