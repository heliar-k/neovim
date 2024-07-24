local M = {}

function M.setup()
  require("cmake-tools").setup({
    cmake_command = "cmake",
    cmake_build_directory = "",
    cmake_build_directory_prefix = "build/",
    cmake_build_options = {},
    cmake_console_size = 10, -- cmake output window height
    cmake_show_console = "always", -- "always", "only_on_error"
    cmake_dap_configuration = {
      name = "cppdbg",
      type = "cpp",
      request = "launch",
      setupcommands = {
        {
          description = "enable pretty-printing for gdb",
          ignorefailures = true,
          text = "-enable-pretty-printing",
        },
      },
    }, -- dap configuration, optional
    cmake_dap_open_command = require("dap").continue,
    cmake_variants_message = {
      short = { show = true },
      long = { show = true, max_length = 40 },
    },
  })
end

return M
