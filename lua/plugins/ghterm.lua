return {
      {
    'YaakovEidelman/ghterm.nvim',
    config = function()
      require('ghterm').setup({
        -- keymap_prefix = '<leader>gh',
        telescope = require('telescope.themes').get_ivy(),
      })
    end,
  }
}
