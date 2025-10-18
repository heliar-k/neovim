local M = {}

function M.setup()
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({})
  local lspconfig = require("lspconfig")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.offsetEncoding = "utf-8"

  vim.lsp.enable("pyright")
  vim.lsp.enable("lua_ls")
  vim.lsp.enable("marksman")
  vim.lsp.config("clangd", { capabilities = capabilities })
end

return M
