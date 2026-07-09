# nvim config

This file lists everything a new machine needs
for this config will work properly.

## Prerequisites

### Core (required for everything)

| Tool | Why | Windows install |
|------|-----|-----------------|
| **Neovim 0.12+** | Config uses the native `vim.lsp.config` / `vim.lsp.enable` API | `winget install Neovim.Neovim` |
| **Git** | lazy.nvim bootstrap, plugin installs, mini.git | `winget install Git.Git` |
| **A C compiler** | Compiling treesitter parsers | MSVC Build Tools (`winget install Microsoft.VisualStudio.2022.BuildTools` + "Desktop development with C++") or `winget install zig.zig` |
| **Node.js + npm** | ts_ls, pyright, html/cssls, prettier (all installed through Mason via npm), tree-sitter CLI | `winget install OpenJS.NodeJS.LTS` |
| **tree-sitter CLI** | Required by nvim-treesitter (main branch) to build/install parsers | `npm install -g tree-sitter-cli` |
| **ripgrep** | Telescope live_grep and the custom multigrep picker | `winget install BurntSushi.ripgrep.MSVC` |
| **curl** | Parser/tool downloads | Ships with Windows 10+ |
| **A Nerd Font** | Statusline/tabline/DBUI icons | e.g. `winget install DEVCOM.JetBrainsMonoNerdFont`, then set it in your terminal |

### Language toolchains (install the ones you use)

| Tool | Why |
|------|-----|
| **Python 3** (with `pip` and `venv`) | pyright targets, debugpy, black/ruff installs |
| **.NET SDK** | Roslyn LSP (C#), csharpier, running/debugging C# with netcoredbg |
| **Rust (rustup)** | rustfmt; rust_analyzer binary itself comes from Mason |

### Build tools for plugins

| Tool | Why |
|------|-----|
| **make** (or MinGW on Windows) | `telescope-fzf-native` builds with `make` as currently configured. On Windows, without make the build fails and the fzf extension won't load (known issue — cmake-based build is the fix, pending). |

### Optional

| Tool | Why |
|------|-----|
| **fd** | Faster Telescope `find_files` (`winget install sharkdp.fd`) |
| **VS Code** (`code` on PATH) | `<leader>gd` opens the current folder in VS Code |

## First boot on a new machine

1. Clone this repo to `~/AppData/Local/nvim` (Windows) or `~/.config/nvim` (Linux/macOS).
2. Start `nvim` — lazy.nvim bootstraps itself and installs plugins.
3. Run `:Lazy restore` to pin all plugins to the committed `lazy-lock.json`.
4. Open `:Mason` and install the non-LSP tools (the `ensure_installed` list in
   `lua/plugins/mason.lua` documents what's expected, but mason.nvim does not
   auto-install it — LSP servers via mason-lspconfig are the only automatic part):
   - Formatters: `black`, `prettier`, `stylua`, `clang-format`, `shfmt`, `csharpier`
   - Debug adapters: `debugpy`, `codelldb`, `netcoredbg`
   - Other: `postgres-language-server`
5. Run `:checkhealth` and fix anything red.

