# nvim-config

Personal neovim config, grown from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
Single-file config (`init.lua`), plugins managed by neovim's built-in `vim.pack`.

See [CHEATSHEET.md](CHEATSHEET.md) for the editing patterns worth practicing.

## What's configured

- **LSP** (via mason, auto-installed): basedpyright + ruff (Python), clangd (C/C++), lua_ls (Lua)
- **Format on save**: ruff for Python, stylua for Lua. C/C++ only formats if the
  project has a `.clang-format` file
- **Search**: telescope (`<space>sf` files, `<space>sg` project grep)
- **Files**: oil.nvim (`-` opens the directory as an editable buffer)
- **Buffers auto-reload** when files change on disk (Claude Code edits show up on focus)

## Setup on a new machine (macOS)

```sh
brew install neovim ripgrep fd tree-sitter-cli
git clone git@github.com:kennedymindeman/nvim-config.git ~/.config/nvim
nvim --headless "+qa"                          # installs plugins
nvim --headless "+MasonToolsInstallSync" "+qa" # installs LSP servers
nvim                                           # done
```

Requires a terminal with Nerd Font glyphs (Ghostty has them built in) and a C
compiler for treesitter parsers (`xcode-select --install`).

The colorscheme is `catppuccin-mocha`; the rest of the terminal matches by
setting the same theme in Ghostty's config (not part of this repo):

```ini
# ~/Library/Application Support/com.mitchellh.ghostty/config
theme = Catppuccin Mocha
```

(helix pairs via `theme = "catppuccin_mocha"` in ~/.config/helix/config.toml)

## Setup on Windows

Not set up yet. When needed: config path is `~/AppData/Local/nvim`, install
neovim/ripgrep/fd/tree-sitter-cli via winget or scoop, and a C compiler
(zig or MSVC) is required for treesitter. Everything else (mason, plugins)
is cross-platform.

## Pulling kickstart updates

Upstream is kept as a remote:

```sh
git fetch upstream
git merge upstream/master
```
