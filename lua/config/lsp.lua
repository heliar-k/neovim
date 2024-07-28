local M = {}

function M.setup()
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({})
  local lspconfig = require("lspconfig")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.offsetEncoding = "utf-8"

  lspconfig.pyright.setup({})
  lspconfig.lua_ls.setup({})
  lspconfig.marksman.setup({})
  lspconfig.clangd.setup({ capabilities = capabilities })
end

return M
