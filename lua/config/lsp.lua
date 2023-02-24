local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup {}

require("lsp-format").setup {}

local lspconfig = require("lspconfig")
local on_attach = function(client)
  require("lsp-format").on_attach(client)
end

lspconfig.pyright.setup { on_attach = on_attach }
lspconfig.lua_ls.setup { on_attach = on_attach }
lspconfig.rust_analyzer.setup { on_attach = on_attach }
