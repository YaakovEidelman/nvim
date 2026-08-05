# Config cleanup backlog

Open items from the config review. Ordered roughly by payoff. Work through one at a time.

mini.clue is set up in `plugins/mini.lua` (`<Leader>`, `g`, `z`, `<C-w>`, `"`, insert
`<C-r>`) with `timeoutlen = 400`. It is on trial — if it goes, keep the lowered
`timeoutlen`.

Still eager by necessity, not oversight: overseer (nvim-dap's `config` calls
`require("overseer").enable_dap()`), mini.nvim (statusline + clue), mason-lspconfig,
persistent-breakpoints (`BufReadPost`, so saved breakpoints load with the file),
indent-blankline.

## 1. Update README

The read me doesn't list nicely all the prerequisites that need to be downloaded such as
`unzip`, and I'm sure there are others.
Also, the readme needs to be made much nicer than it is right now.
