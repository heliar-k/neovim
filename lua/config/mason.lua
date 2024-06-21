require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require('mason-tool-installer').setup {
  auto_update = true,
  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {
    -- lsp
    "clangd",                -- lsp for c/c++
    "cmake-language-server", -- lsp for cmake
    "marksman",              -- lsp for markdown
    "lua-language-server",   -- lsp for lua
    "yaml-language-server",  -- lsp for yaml
    "ruff-lsp",              -- lsp for python
    "taplo",                 -- lsp for toml
    -- dap
    "codelldb",              -- debugger for c/c++
    "cpptools",              -- debugger for c/c++
    "debugpy",               -- debugger for python
    -- formatter
    "clang-format",          -- formatter for c/c++
    "cmakelang",             -- formatter for cmake
    "isort",                 -- import optimizer for python
    "prettier",              -- formatter for javascript/typescript
    "ruff",                  -- formatter and linter for python
    "shfmt",                 -- formatter for shell scripts
    "stylua",                -- formatter for lua
  }
}
