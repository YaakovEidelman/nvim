# nvim config

Everything a fresh machine needs. Install the system packages for your OS, clone
this repo, start `nvim`.

Clone to `%LOCALAPPDATA%\nvim` on Windows, `~/.config/nvim` on Linux.

There are scripts in `scripts/` that run these installs for you — `windows.ps1`
(winget) and `arch.sh` (pacman). Both install the required list only; pass
`-Optional` / `--optional` to get the extras too. Other distros: read the Linux
list and use your own package manager.

"Required" means a first boot needs it. The eight LSP servers in
`lua/lsp/servers.lua` install themselves on first start whether you want them or
not, and four of those are npm packages, so node is not optional. Nothing
auto-installed needs python or dotnet — those are only for the manual
`:MasonInstall` line, so they live under optional.

## Windows

- Neovim 0.12+ — `winget install Neovim.Neovim`
- Git — `winget install Git.Git`
- MSVC C/C++ compiler — `winget install Microsoft.VisualStudio.2022.BuildTools -e --override "--quiet --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"`
- CMake — `winget install Kitware.CMake`
- Node.js LTS + npm — `winget install OpenJS.NodeJS.LTS`
- ripgrep — `winget install BurntSushi.ripgrep.MSVC`
- A Nerd Font — `winget install DEVCOM.JetBrainsMonoNerdFont`, then set it in your terminal
- `curl`, `tar`, PowerShell 5.1 — already in Windows 10/11, nothing to do
- tree-sitter CLI — no good winget package, get it from Mason: `:MasonInstall tree-sitter-cli`

Optional:

- Python 3 — only for black, ruff and debugpy — `winget install Python.Python.3.13`
- .NET SDK — only for Roslyn (C#) and csharpier — `winget install Microsoft.DotNet.SDK.9`
- Rust toolchain — only for `rustfmt` — `winget install Rustlang.Rustup`
- `fd` — faster Telescope `find_files` — `winget install sharkdp.fd`
- VS Code — `<leader>gd` opens the cwd in it — `winget install Microsoft.VisualStudioCode`

## Linux (Arch)

```
sudo pacman -S --needed neovim git gcc make cmake nodejs npm ripgrep unzip \
  tree-sitter-cli ttf-jetbrains-mono-nerd wl-clipboard
```

- `neovim` must be 0.12+. If the repo version is older, use `neovim-git` from the AUR.
- `gcc` and `make` come with `base-devel` if you already have it. Only those two
  matter here — gcc compiles treesitter parsers, and gcc plus `cmake` build
  telescope-fzf-native.
- `unzip` is how Mason unpacks stylua and codelldb. It is not in `base` and
  nothing pulls it in, so it is usually the one that's missing.
- Mason also needs `curl`, `tar` and `gzip`, but `tar` and `gzip` ship in `base`
  and `curl` is a dependency of pacman itself, so on Arch they are already there.
  On a minimal non-Arch system, install them.
- `wl-clipboard` is for Wayland — use `xclip` on X11. `clipboard = "unnamedplus"`
  in `lua/options.lua` silently does nothing without one of them.

Optional:

- `python` and `python-pip` — only for black, ruff and debugpy
- `dotnet-sdk` — only for Roslyn (C#) and csharpier
- `rustup` — only for `rustfmt`
- `fd` — faster Telescope `find_files`
- `postgresql` / `mariadb-clients` — dadbod DBUI needs the client CLI of whatever
  database you connect to

## Mason packages

LSP servers install themselves on first start, from the list in `lua/lsp/servers.lua`:
ts_ls, pyright, lua_ls, clangd, rust_analyzer, html, cssls, postgres_lsp.

Everything else is manual. Formatters, debug adapters and the C# server:

```
:MasonInstall stylua prettier black ruff clang-format shfmt csharpier debugpy codelldb netcoredbg roslyn tree-sitter-cli
```

## First boot

1. Clone this repo into the config path above.
2. Start `nvim` — lazy.nvim bootstraps itself and installs plugins.
3. `:Lazy restore` to pin everything to the committed `lazy-lock.json`.
4. Run the `:MasonInstall` line above.
5. `:checkhealth` and fix anything red.

## Troubleshooting

**telescope-fzf-native.** It's optional. If the toolchain is missing, Telescope
falls back to its built-in Lua sorter and shows a one-time notification. After
installing CMake and a compiler, run `:Lazy build telescope-fzf-native.nvim`.

**`cannot open output file libfzf.dll: Permission denied` on Windows.** That's a
file lock, not a toolchain problem — once nvim has loaded the fzf extension it
holds `build/libfzf.dll` open and the linker can't overwrite it. Close all
Neovim instances and build from a terminal:

```
cd /c/Users/yeide/AppData/Local/nvim-data/lazy/telescope-fzf-native.nvim
rm -rf build
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cmake --install build --prefix build
```

If it still fails with nvim closed, check for stray processes (`Get-Process nvim`)
or antivirus briefly locking the new `.dll`.
