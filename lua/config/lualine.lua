require('lualine').setup({
  sections = {
    lualine_c = {
      ...,
      'lsp_progress'
    }
  },
  options = {
    theme = "auto"
  }
})
