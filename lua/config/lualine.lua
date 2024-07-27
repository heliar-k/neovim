require("lualine").setup({
  sections = {
    lualine_c = {
      ...,
      "lsp_progress",
    },
    lualine_z = {
      {
        "datetime",
        -- options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
        style = "%Y-%m-%d|%H:%M:%S",
      },
    },
  },
  options = {
    theme = "auto",
    disabled_filetypes = {
      statusline = {
        "alpha",
        "dashboard",
        "aerial",
        "dapui_.",
        "neo-tree",
        "NvimTree",
        "Outline"
      },
    },
  },
})
