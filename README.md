# Neovim Configuration

A modern, feature-rich Neovim IDE configuration using **native LSP** (Neovim 0.10+) with support for 14+ programming languages, advanced debugging, git workflows, and Arduino development.

## 🚀 Features

### Native Language Server Protocol (LSP)

This configuration uses **Neovim's native LSP** without wrapper plugins like nvim-lspconfig. Language servers are configured directly via Neovim's LSP API in individual files under `/lsp/`.

**Supported Language Servers:**
- **lua_ls** – Lua (LuaJIT runtime, Vim globals)
- **rust_analyzer** – Rust (lens, debug, run, test support)
- **tsserver** – TypeScript/JavaScript/TSX/JSX
- **pyright** – Python
- **clangd** – C/C++/Objective-C
- **eslint** – JavaScript/TypeScript linting
- **tailwindcss** – CSS framework intelligence
- **cssls** – CSS
- **ocamllsp** – OCaml
- **texlab** – LaTeX
- **docker_language_server** – Docker
- **pest_ls** – Pest parser expressions
- **flux-lsp** – InfluxDB Flux queries
- **arduino_language_server** – Arduino sketches (.ino)

### IDE Features

- **Fuzzy Finding**: Telescope for files, live grep, buffers, projects, diagnostics
- **File Explorer**: NvimTree with git integration
- **Debugging (DAP)**: Full breakpoint support with UI; Java debugging via nvim-jdtls
- **Git Integration**: Gitsigns, Fugitive, Rhubarb (GitHub integration)
- **Auto-completion**: nvim-cmp with LSP, snippet, buffer, and path sources
- **Syntax Highlighting**: Treesitter with 30+ parsers (incremental selection, playground)
- **Formatting**: LSP and none-ls (prettierd) async formatting
- **Session Management**: auto-session for project persistence
- **Arduino Support**: arduino-cli integration for compile, upload, serial monitor
- **AI Assistant**: CodeCompanion for OpenAI-powered code suggestions
- **Project Navigation**: Harpoon for quick file marking (Ctrl+1-4), project switching

### Editing Enhancements

- **Surround.nvim**: `cs`, `ds`, `ys` bracket/tag operations
- **Comment.nvim**: `gcc` line/block commenting
- **nvim-autopairs**: Auto-pair brackets and tags
- **Visual-multi**: Multiple cursor support
- **Todo-comments**: Highlight and organize TODOs (`:TodoTelescope`)
- **Auto-save**: Automatic file saving
- **Undo tree**: Visual undo history (`:UndotreeToggle`)
- **Smooth scrolling**: Animated page scrolling

## 📋 Default Keymaps

### Navigation
- `<C-h/j/k/l>` – Window navigation
- `<leader>pf` – Find files (Telescope)
- `<leader>ps` – Live grep (Telescope)
- `<leader>e` – Toggle file explorer (NvimTree)
- `Ctrl+1-4` – Jump to Harpoon marked files
- `<leader>p` – Switch projects (Telescope + project.nvim)

### LSP
- `gd` – Goto definition
- `gD` – Goto declaration
- `gi` – Goto implementation
- `gr` – Goto references
- `K` – Hover documentation
- `<leader>rn` – Rename symbol
- `<leader>ca` – Code actions
- `<leader>cf` – Format buffer
- `[d` / `]d` – Next/previous diagnostic
- `<leader>ds` – Show line diagnostics

### Debugging (DAP)
- `F5` – Continue
- `F10` – Step over
- `F11` – Step into
- `F12` – Step out
- `<leader>b` – Toggle breakpoint
- `<leader>B` – Conditional breakpoint
- `<leader>du` – Toggle DAP UI
- `<leader>de` – Evaluate expression

### Editing
- `gcc` – Toggle comment (Comment.nvim)
- `gnn` / `grn` / `grc` / `grm` – Treesitter incremental selection
- `cs` – Change surround (Surround.nvim)
- `ds` – Delete surround
- `ys` – Add surround
- `<leader>st` – Toggle terminal (7-line split)
- `<leader>y` – Yank to clipboard (visual)
- `<leader>Y` – Yank whole buffer to clipboard

### Git
- `:Git` – Open Fugitive interface
- `:GBrowse` – Open GitHub URL in browser (Rhubarb)
- Gitsigns signs in left margin show git changes

### Arduino (Custom Integration)
- `<leader>au` – Compile and upload sketch (arduino-cli)
- `<leader>am` – Open serial monitor (split window)

### Sessions & Utilities
- `<leader>qs` – Save session
- `<leader>qr` – Restore session
- `:TodoTelescope` – List all TODOs
- `:UndotreeToggle` – Visual undo history
- `<leader>qq` – Quit Neovim

## 📁 Directory Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── lua/
│   ├── plugins.lua       # Packer setup
│   ├── plugins/          # Plugin declarations (core, lsp, ui, etc.)
│   ├── config/           # Feature configurations
│   │   ├── lsp.lua       # Native LSP configuration
│   │   ├── lsp/          # Language-specific LSP setup (jdtls, null-ls)
│   │   ├── keymaps.lua   # All keybindings
│   │   ├── options.lua   # Vim options
│   │   ├── cmp.lua       # Completion setup
│   │   ├── dap.lua       # Debugging configuration
│   │   └── ...
│   ├── custom/           # Custom user code (Arduino, etc.)
│   ├── cameleer/         # Custom navigation plugin
│   └── utils.lua         # Utility functions
├── lsp/                  # Native LSP server configurations
│   ├── lua_ls.lua
│   ├── rust_analyzer.lua
│   ├── tsserver.lua
│   ├── pyright.lua
│   ├── clangd.lua
│   └── ...
├── ftplugin/             # Filetype-specific setup
│   ├── java.lua          # Java configuration (jdtls)
│   └── lua.lua           # Lua configuration
└── plugin/               # Compiled Packer specs
    └── packer_compiled.lua
```

## 🔧 Installation

1. **Clone or copy** this configuration to `~/.config/nvim/`
2. **Install Neovim 0.10+** – Required for native LSP API
3. **Install Packer** – Plugin manager
   ```bash
   git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
   ```
4. **Start Neovim** and run `:PackerSync` to install all plugins
5. **Install language servers** via Mason (`:Mason` command) or manually

## 🎯 Configuration Highlights

### Native LSP Setup
All LSP servers are configured in `/lua/config/lsp.lua` and individual files under `/lsp/`. This approach gives direct access to Neovim's LSP API without abstraction layers.

```lua
-- Example: Direct LSP configuration without nvim-lspconfig
vim.lsp.config("rust_analyzer", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = { ... }
})
vim.lsp.enable({ "rust_analyzer" })
```

### Diagnostics
- Virtual text with bullet prefix
- Rounded borders for floating previews
- Custom signs with icons
- Severity-sorted diagnostics

### Java Development
Special Java support via `ftplugin/java.lua`:
- **nvim-jdtls** for enhanced LSP features
- DAP with breakpoints and test debugging
- Debug adapter bundles (java-debug-adapter, java-test)
- Workspace: `~/.cache/jdtls/workspace/`

### Formatting & Linting
- **LSP-based formatting** via language servers
- **none-ls** for additional linting (e.g., prettierd for code formatting)
- **ESLint** with custom handler for JavaScript/TypeScript

### Arduino Development
Custom integration in `/lua/custom/arduino.lua`:
- Compile sketches with arduino-cli
- Upload to board
- Monitor serial output
- Language server support for `.ino` files

## 📦 Plugin List (40+ plugins)

**Core**: packer.nvim, plenary.nvim, nvim-web-devicons
**UI**: rose-pine (theme), lualine (statusline), nvim-tree, alpha (dashboard), nui, notify
**Navigation**: telescope, harpoon, project.nvim, auto-session
**Editing**: surround.nvim, comment.nvim, autopairs, colorizer, todo-comments
**LSP & Completion**: nvim-cmp, mason, nvim-treesitter, nvim-jdtls, none-ls
**Debugging**: nvim-dap, nvim-dap-ui, mason-nvim-dap
**Git**: gitsigns, fugitive, rhubarb, mini.diff
**AI**: codecompanion.nvim
**Utilities**: undotree, visual-multi, which-key, auto-save, neoscroll, cutlass

## ⚙️ Requirements

- **Neovim**: 0.10+ (for native LSP API)
- **Packer.nvim**: Plugin manager
- **Python**: Required for treesitter and some plugins
- **Git**: For plugin installation and git integration
- **Language Servers**: Installed via Mason (`:Mason`)
- **Node.js**: For TypeScript/JavaScript language server and others
- Optional: **arduino-cli** for Arduino support, **OPENAI_API_KEY** for CodeCompanion

## 🎨 Theme

- **Color Scheme**: [rose-pine](https://github.com/rose-pine/neovim) (moon variant)
- **Icons**: nvim-web-devicons for file type indicators
- **Fonts**: Recommended to use a Nerd Font for proper icon rendering

## 🔌 Extending the Configuration

### Adding a New Language Server
1. Create `/lsp/your_server.lua` with configuration
2. Add to `lsp_servers` list in `/lua/config/lsp.lua`
3. Call `:Mason` to install the server

### Adding a Plugin
1. Declare in `/lua/plugins/` (e.g., `editing.lua`, `lsp.lua`)
2. Add configuration in `/lua/config/` if needed
3. Run `:PackerSync`

### Custom Keymaps
Edit `/lua/config/keymaps.lua` and add your mappings following the existing structure.

## 📝 Notes

- **Leader key**: `<Space>` (spacebar)
- **Auto-save** is enabled by default
- **Sessions** are saved automatically (toggle with `<leader>q`s/r)
- **Persistent undo** stored in `~/.local/state/nvim/undo/`
- **Relative line numbers** enabled for easier navigation

## 🤝 Contributing

Feel free to extend and customize this configuration for your workflow. The modular structure makes it easy to add new plugins and configurations.

## 📄 License

Personal configuration, feel free to fork and adapt!

---

**Built for Neovim 0.10+ with native LSP** ✨
