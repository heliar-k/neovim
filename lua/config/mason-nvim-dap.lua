require('mason-nvim-dap').setup({
  ensure_installed = { "python", "codelldb" },
  automatic_setup = true,
})

require 'mason-nvim-dap'.setup_handlers {}
