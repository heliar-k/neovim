-- opencode 插件被禁用时跳过 statusline 组件（恢复启用后自动生效）
local ok, opencode = pcall(require, "opencode")
local lualine_z = {
  {
    "datetime",
    -- options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
    style = "%Y-%m-%d|%H:%M",
  },
}
if ok then
  table.insert(lualine_z, opencode.statusline)
end

require("lualine").setup({
  sections = {
    lualine_c = {
      ...,
      "lsp_progress",
    },
    lualine_z = lualine_z,
  },
  options = {
    theme = "auto",
    disabled_filetypes = {
      statusline = {
        "snacks_dashboard",
        "aerial",
        "dapui_.",
        "neo-tree",
        "NvimTree",
        "Outline",
      },
    },
  },
})
