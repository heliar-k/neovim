local rust_tools = {}

function rust_tools.setup()
  local rt = require("rust-tools")

  local mason_registry = require("mason-registry")

  local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
  local codelldb_path = codelldb_root .. "adapter/codelldb"
  local liblldb_name
  local system_name = vim.loop.os_uname().sysname
  if system_name:match("Windows") then
    liblldb_name = "liblldb.dll"
  elseif system_name:match("Darwin") then
    liblldb_name = "liblldb.dylib"
  else
    liblldb_name = "liblldb.so"
  end
  local liblldb_path = codelldb_root .. "lldb/lib/" .. liblldb_name

  local opts = {
    server = {
      standalone = true,
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      checkOnSave = {
        allFeatures = true,
        overrideCommand = {
          "cargo",
          "clippy",
          "--workspace",
          "--message-format=json",
          "--all-targets",
          "--all-features",
        },
      },
    },
    dap = { adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path) },
  }

  rt.setup(opts)
end

return rust_tools
