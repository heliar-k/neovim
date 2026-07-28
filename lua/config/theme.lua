-- Centralized theme configuration.
-- All theme switching routes through here so there's one place to change themes.
local M = {}

M.dark = "tokyonight"
M.light = "github_light"

function M.set_dark()
  vim.opt.background = "dark"
  vim.cmd("colorscheme " .. M.dark)
  require("lualine").setup({ options = { theme = "auto" } })
end

function M.set_light()
  vim.opt.background = "light"
  vim.cmd("colorscheme " .. M.light)
  require("lualine").setup({ options = { theme = "auto" } })
end

return M
