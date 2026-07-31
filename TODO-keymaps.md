# Keymap migration

Moving plugin-owned bindings into lazy.nvim `keys = { ... }` specs, one plugin at a time.
This is item 1 (and most of item 2) from `TODO.md`.

## Why this works

`keys =` does not defer the mapping. lazy.nvim creates a real mapping at startup — a stub
that loads the plugin, deletes itself and replays the keystroke — and copies your `desc`
onto that stub (`lazy/core/handler/keys.lua:142`). So the binding is visible to
`:Telescope keymaps`, `:map`, `:verbose map` and any hint popup from the first millisecond
of a session, even though the plugin has not loaded.

Locality and discoverability are therefore not in tension. The thing that makes bindings
findable is `desc`, not file layout.

## Rules

1. Plugin-owned bindings go in that plugin's `keys =` spec. Core-Neovim bindings stay in
   `keymaps.lua`.
2. **Every mapping gets a `desc`.** No exceptions. A mapping without one is invisible in
   every lookup, which is the actual reason the config feels hard to navigate.
3. Descriptions are prefixed with their group: `Find: files`, `Debug: step over`,
   `DB: toggle UI`. Then fuzzy-searching the group name returns the whole family
   regardless of which file each binding lives in.
4. A `utils/` module exposes a function and never binds a key. The spec does the binding.
5. Add `cmd = "..."` alongside `keys` when the plugin has user commands, so typing the
   command directly still loads it.

## Exceptions — leave these where they are

- **netrw maps** (`autocmd.lua`): buffer-local, and must be applied after netrw sets its
  own maps inside `NetrwMaps()`. The scheduled `FileType` autocmd is correct.
- **codediff in-view maps** (`plugins/codediff.lua` opts): buffer-local to a diff tab, the
  plugin owns their lifecycle.
- Plugins deliberately set `lazy = false` (roslyn, treesitter) gain no loading benefit, but
  their bindings still belong in the spec for locality.

## Remaining

- [ ] **vim-dadbod / dadbod-ui** (`plugins/nvim-dadbod.lua`) — fixes item 3 from `TODO.md`
      at the same time. `<leader>eq` (visual, execute selection) currently never gets bound
      because vim-dadbod is `lazy = true` with no trigger, so its `config` never runs.
      As a `keys` entry with `mode = "v"` it works and becomes the dadbod load trigger.
      `<leader>sql` and `<leader>sf` move from `init` to `keys` on the dadbod-ui spec.

- [ ] **conform** (`keymaps.lua`) — `<M-F>` calls `require("conform").format()` from
      `keymaps.lua`, so it is a plugin binding sitting in the core file. Move to a `keys`
      entry on the conform spec, which also lets `event = "VeryLazy"` go away.

- [ ] **overseer** (`plugins/dap.lua`) — has no bindings at all right now; tasks are only
      reachable by typing `:OverseerRun`. Worth adding `cmd = { "OverseerRun", "OverseerToggle" }`
      and a described binding while passing through. Note nvim-dap's `config` ends with
      `require("overseer").enable_dap()`, so overseer must be loadable at that point.

## Then: backfill `keymaps.lua`

Once the plugin specs are done, `keymaps.lua` holds only core bindings — and most of them
still have no `desc`: window navigation, the alt-key line moves, the visual-mode indent
rebinds, `<leader>tn`, `<C-bs>`/`<C-H>`, `<C-e>`, `gd`. Add descriptions using the same
group-prefix convention (`Window: focus left`, `Edit: move line down`).

At that point the small local `map(mode, lhs, rhs, desc)` helper from item 11 is worth
adding, so the file reads as one scannable table of bindings instead of stylua-wrapped
six-line calls.

## Open decisions

- **dap-ui auto-open is now load-gated.** nvim-dap-ui loads only on `<leader>dt`. The three
  `dap.listeners` in its config have commented-out bodies, so nothing auto-opens today and
  this is fine. But if you ever uncomment `dapui.open()` in `event_initialized`, it will not
  fire — dap-ui won't be loaded when a session starts. To get auto-open back, dap-ui needs
  to load with dap (move the listeners into nvim-dap's `config`, or drop the `keys` trigger).



- **mini.clue** — ships inside the mini.nvim already installed (`lua/mini/clue.lua`), so it
  costs zero new plugins. Press `<leader>`, get a window listing every continuation with
  its description. This is the payoff for the `desc` discipline above. Needs
  `vim.o.timeoutlen` lowered (~400) or the popup feels sluggish. Do this last, once
  descriptions exist to display.

- **`<leader>b` collision** — codediff binds `<leader>b` to toggle its explorer, and there
  are four global `<leader>b*` maps (`bb`, `bn`, `bi`, `bp`). Inside a codediff tab all
  four stall for `timeoutlen` before resolving. Rebinding one side is the real fix;
  lowering `timeoutlen` only makes it less painful.
