require('lualine').setup({
  sections = {
    lualine_a = {
      {
        'datetime',
        -- options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
        style = 'us'
      }
    },
    lualine_c = {
      ...,
      'lsp_progress',
    }
  },
  options = {
    theme = "auto"
  },
  disabled_filetypes = {
    statusline = {
      "alpha",
      "NvimTree"
    },
    winbar = {
      "alpha",
      "NvimTree"
    },
  },
})
