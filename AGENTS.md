# AGENTS.md - Neovim Configuration Guide

This is a Neovim configuration repository written in Lua. The codebase uses `lazy.nvim` for plugin management and `conform.nvim` / `stylua` for code formatting.

## Build / Lint / Test Commands

### Formatting

This repository uses **stylua** for Lua code formatting (configured in `.stylua.toml`):

```bash
# Format all Lua files with stylua
stylua lua/

# Check formatting without modifying files
stylua --check lua/
```

The project also uses **conform.nvim** for on-save formatting. When editing Lua files in Neovim, the formatter runs automatically on save.

### Plugin Management

The configuration uses **lazy.nvim** for plugin management:

```bash
# Inside Neovim, sync plugins
:Lazy sync

# Check plugin status
:Lazy

# Update plugins
:Lazy update
```

### Linting

Lua code is linted via **lua_ls** (Neovim's built-in Lua language server). The LSP provides:
- Syntax checking
- Type checking (with luacheck annotations)
- Auto-completion
- Code navigation

### Testing

This is a Neovim configuration repository, not a traditional software project. There are no unit tests. However, you can verify the configuration works by:

```bash
# Validate Neovim configuration loads correctly
nvim --headless -c "quit" +qa

# Check for Lua syntax errors
luac -p lua/**/*.lua

# Test specific configuration file loads
nvim --headless -c "lua require('config.lsp')" -c "quit" +qa
```

## Code Style Guidelines

### General Principles

1. **2-space indentation** - Configured in `.stylua.toml` (`indent_type = "Spaces"`)
2. **No trailing whitespace** - Clean, compact code
3. **Descriptive naming** - Use clear, descriptive variable and function names
4. **Modular structure** - Split configuration into logical modules under `lua/config/`

### File Organization

```
lua/
├── config/          -- Plugin configurations (lsp.lua, telescope.lua, etc.)
├── editor.lua       -- Core editor settings
├── keybindings.lua  -- Key mappings
├── plugin.lua       -- Plugin list and lazy.nvim setup
└── utils/           -- Utility functions
```

### Module Pattern

Use the module pattern for configuration files:

```lua
-- lua/config/example.lua
local M = {}

function M.setup()
  -- Configuration code here
  local plugin = require("plugin_name")
  plugin.setup({ option = value })
end

return M
```

Then require and call in `plugin.lua`:
```lua
{
  "author/plugin-name",
  config = function()
    require("config.example").setup()
  end,
},
```

### Imports and Requires

- Use `local` for all require statements
- Group requires at the top of files
- Use meaningful variable names for require results

```lua
local lspconfig = require("lspconfig")
local mason = require("mason")
local utils = require("utils")
```

### Naming Conventions

- **Files**: lowercase with underscores (`nvim-treesitter.lua`)
- **Modules**: lowercase (`config.lsp`)
- **Functions**: snake_case (`setup()`, `setup_lsp()`)
- **Variables**: snake_case (`local capabilities = ...`)
- **Constants**: UPPERCASE or prefixed with `k` (e.g., `k_default_opts`)

### Neovim API Usage

- Use `vim.opt` for options (not `vim.cmd("set ...")`)
- Use `vim.g` for global variables
- Use `vim.bo` for buffer-local options
- Use `vim.wo` for window-local options
- Use `vim.api.nvim_*` for advanced functionality

```lua
-- Good
vim.opt.tabstop = 4
vim.g.mapleader = " "
vim.bo.expandtab = true

-- Avoid
vim.cmd("set tabstop=4")
```

### Keybinding Definitions

Use `vim.api.nvim_set_keymap` or which-key for mappings:

```lua
-- Simple mappings
local map = vim.api.nvim_set_keymap
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true })

-- With which-key (preferred for leader keys)
wk.add({
  { "<leader>f", group = "Telescope" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
})
```

### Error Handling

- Use `pcall` for risky operations
- Add `:diagnostic disable-next-line` comments for intentional LSP suppressions
- Validate dependencies before requiring

```lua
-- Safe require with fallback
local ok, module = pcall(require, "optional_plugin")
if ok then
  module.setup()
end

-- Suppress specific LSP warnings
---@diagnostic disable-next-line: deprecated
local deprecated_fn = vim.loop...
```

### Comments

- Use `--` for single-line comments
- Use `--[[ ... ]]` for block comments
- Add Chinese comments for clarity (as per project convention)
- Document configuration options with comments

```lua
-- 这是单行注释
--[[
这是多行注释
跨越多行
]]

-- 配置说明
vim.opt.tabstop = 4 -- Tab 宽度
```

### Type Annotations (Optional)

Use LuaLS annotations for better LSP support:

```lua
---@class PluginConfig
---@field enable boolean
---@field option string|nil

---@param opts PluginConfig
local function setup(opts)
  if opts.enable then
    -- ...
  end
end
```

### Plugin Configuration Pattern

Follow this pattern for all plugin configurations:

```lua
-- In plugin.lua
{
  "author/plugin-name",
  event = "BufReadPre",        -- or cmd = {"PluginCmd"}, lazy = true/false
  dependencies = { "dep1", "dep2" },
  config = function()
    require("config.plugin_name").setup()
  end,
},

-- In lua/config/plugin_name.lua
local M = {}

M.setup = function()
  require("plugin_name").setup({
    -- options
  })
end

return M
```

### Prefer Functional Setup

- Use `config = function()` in plugin definitions
- Keep setup functions pure when possible
- Return the module for testing access

### Common Patterns

**Conditional loading:**
```lua
-- Only load when not in VSCode
if not vim.g.vscode then
  require("plugin")
end
```

**Feature detection:**
```lua
local have_make = vim.fn.executable("make") == 1
local have_cmake = vim.fn.executable("cmake") == 1
```

**Lazy loading:**
```lua
{ "plugin/name", lazy = true, cmd = { "PluginCmd" } }
{ "plugin/name", lazy = true, event = { "BufReadPre" } }
```

## Cursor / Copilot Rules

No additional Cursor rules (`.cursor/rules/`, `.cursorrules`) or Copilot rules (`.github/copilot-instructions.md`) were found in this repository.

## Verification Checklist

Before committing changes:

- [ ] Run `stylua --check lua/` to verify formatting
- [ ] Ensure Neovim loads without errors: `nvim --headless -c "quit" +qa`
- [ ] Check for Lua syntax errors: `luac -p lua/**/*.lua`
- [ ] Verify all required plugins are available in lazy.nvim
- [ ] Test keybindings work correctly

## Additional Notes

- The project uses Chinese comments for educational purposes
- Leader key is set to `<Space>`
- Configuration targets Neovim 0.9+ (uses `vim.loader.enable()`)
- Uses both `vim.opt` and `vim.o` for options (both are valid)
