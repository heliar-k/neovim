local dap = require('dap')

require('mason-nvim-dap').setup({
  ensure_installed = { "bash", "python", "codelldb" },
  automatic_setup = true,
})

require 'mason-nvim-dap'.setup_handlers {}
