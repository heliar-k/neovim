local dap = require("dap")
local dapui = require("dapui")

require("mason-nvim-dap").setup({})
require 'mason-nvim-dap'.setup_handlers {
  function(source_name)
    -- all sources with no handler get passed here


    -- Keep original functionality of `automatic_setup = true`
    require('mason-nvim-dap.automatic_setup')(source_name)
  end,
  python = function(source_name)
    dap.adapters.python = {
      type = "executable",
      command = "/usr/bin/python3",
      args = {
        "-m",
        "debugpy.adapter",
      },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}", -- This configuration will launch the current file if used.
      },
    }
  end,
}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
