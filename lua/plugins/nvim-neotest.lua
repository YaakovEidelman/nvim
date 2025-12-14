return {
    --   {
    --   "nvim-neotest/neotest",
    --   dependencies = {
    --     "Issafalcon/neotest-dotnet",
    --   },
    --   config = function()
    --     require("neotest").setup({
    --       adapters = {
    --         require("neotest-dotnet")({
    --             dap = {
    --                 args = { justMyCode = false },
    --                 adapter_name = "netcoredbg",
    --             },
    --             custom_attributes = {
    --
    --             },
    --             dotnet_additional_args = {
    --
    --             },
    --         })
    --       }
    --     })
    --   end,
    -- }

}
