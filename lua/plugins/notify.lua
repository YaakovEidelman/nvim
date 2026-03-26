return {
    {
        "rcarriga/nvim-notify",
        -- event = "VeryLazy",
        config = function()
            local notify = require("notify")

            notify.setup({
                stages = "static",
                timeout = 5000,
                render = "simple",
                top_down = false,
            })

            vim.notify = notify
        end,
    },
}
