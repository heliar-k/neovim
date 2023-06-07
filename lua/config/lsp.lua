local M = {}
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup {}
local lspconfig = require("lspconfig")


local on_attach = function(client, bufnr)
  -- Configure formatting
  require("config.null-ls.formatters").setup(client, bufnr)
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = 'utf-8'


lspconfig.pyright.setup { on_attach = on_attach }
lspconfig.lua_ls.setup { on_attach = on_attach }
lspconfig.rust_analyzer.setup { on_attach = on_attach }
lspconfig.marksman.setup { on_attach = on_attach }
lspconfig.clangd.setup { on_attach = on_attach, capabilities = capabilities }


local opts = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

function M.setup()
  -- null-ls
  require("config.null-ls").setup(opts)
end

return M
