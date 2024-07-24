local M = {}
local nls_utils = require("config.null-ls.utils")
local nls_sources = require("null-ls.sources")
local method = require("null-ls").methods.FORMATTING
M.autoformat = false
function M.toggle()
  M.autoformat = not M.autoformat
  print(string.format("Toggle autoformat from %s to %s", not M.autoformat, M.autoformat))
end

function M.format(bufnr)
  if M.autoformat then
    nls_utils.async_formatting(bufnr)
    -- vim.lsp.buf.format({
    -- async = false,
    -- timeout_ms = 2000,
    -- })
  end
end

function M.setup(client, bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local enable = false
  if M.has_formatter(filetype) then
    enable = client.name == "null-ls"
  else
    enable = not (client.name == "null-ls")
  end
  client.server_capabilities.document_formatting = enable
  client.server_capabilities.document_range_formatting = enable
  if client.supports_method("textDocument/formatting") then
    vim.cmd([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua require("config.null-ls.formatters").format(bufnr)
      augroup END
    ]])
  end
end

function M.has_formatter(filetype)
  local available = nls_sources.get_available(filetype, method)
  return #available > 0
end

function M.list_registered(filetype)
  local registered_providers = nls_utils.list_registered_providers_names(filetype)
  return registered_providers[method] or {}
end

function M.list_supported(filetype)
  local supported_formatters = nls_sources.get_supported(filetype, "formatting")
  table.sort(supported_formatters)
  return supported_formatters
end

return M
