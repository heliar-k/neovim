local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = {
    "pyright",
    "sumneko_lua",
    "rust_analyzer"
  }
})

require("lsp-format").setup {}

local lspconfig = require("lspconfig")
local on_attach = function(client)
  require("lsp-format").on_attach(client)
end

lspconfig.pyright.setup { on_attach = on_attach }
lspconfig.sumneko_lua.setup { on_attach = on_attach }
lspconfig.rust_analyzer.setup { on_attach = on_attach }
