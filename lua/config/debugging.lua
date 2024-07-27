local debugging = {}

function debugging.setup()
  local dap = require("dap")

  -- override the default icon and highlight color
  local sign = vim.fn.sign_define
  local dap_breakpoint = {
    error = {
      text = "",
      texthl = "DapBreakpoint",
      linehl = "DapBreakpoint",
      numhl = "DapBreakpoint",
    },
    condition = {
      text = "ﳁ",
      texthl = "DapBreakpoint",
      linehl = "DapBreakpoint",
      numhl = "DapBreakpoint",
    },
    rejected = {
      text = "",
      texthl = "DapBreakpint",
      linehl = "DapBreakpoint",
      numhl = "DapBreakpoint",
    },
    logpoint = {
      text = "",
      texthl = "DapLogPoint",
      linehl = "DapLogPoint",
      numhl = "DapLogPoint",
    },
    stopped = {
      text = "",
      texthl = "DapStopped",
      linehl = "DapStopped",
      numhl = "DapStopped",
    },
  }
  sign("DapBreakpoint", dap_breakpoint.error)
  sign("DapBreakpointCondition", dap_breakpoint.condition)
  sign("DapBreakpointRejected", dap_breakpoint.rejected)
  sign("DapLogPoint", dap_breakpoint.logpoint)
  sign("DapStopped", dap_breakpoint.stopped)

  local mason_registry = require("mason-registry")

  -- dap for cpp
  local cpp_dap_executable = mason_registry.get_package("cpptools"):get_install_path()
    .. "/extension/debugAdapters/bin/OpenDebugAD7"
  dap.adapters.cpp = {
    id = "cppdbg",
    type = "executable",
    command = cpp_dap_executable,
  }


  -- dap.configurations.rust = {
  --   {
  --     type = "rust",
  --     request = "launch",
  --     name = "lldbrust",
  --     program = function()
  --       local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
  --       local metadata = vim.fn.json_decode(metadata_json)
  --       local target_name = metadata.packages[1].targets[1].name
  --       local target_dir = metadata.target_directory
  --       return target_dir .. "/debug/" .. target_name
  --     end,
  --     args = function()
  --       -- 同样的进行命令行参数指定
  --       local inputstr = vim.fn.input("CommandLine Args:", "")
  --       local params = {}
  --       for param in string.gmatch(inputstr, "[^%s]+") do
  --         table.insert(params, param)
  --       end
  --       return params
  --     end,
  --   },
  -- }

  -- dap for python
  -- require("dap-python").setup( --[[ debugpy_root.. "/venv/bin/python" --]])
  -- require('dap-python').test_runner = 'pytest'
  --
  dap.adapters.python = {
    type = "executable",
    command = "debugpy-adapter",
  }

  local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  dap.configurations.python = {
    {
      -- The first three options are required by nvim-dap
      type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = "launch",
      name = "Python: Launch file",
      program = "${file}", -- This configuration will launch the current file if used.
      pythonPath = venv_path and (venv_path .. "/bin/python") or nil,
    },
  }

  require("nvim-dap-virtual-text").setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
    show_stop_reason = true,
    commented = true,
    only_first_definition = true,
    all_references = true,
    display_callback = function(variable, _buf, _stackframe, _node)
      return " " .. variable.name .. " = " .. variable.value .. " "
    end,
    -- experimental features:
    virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
  })

  local dapui = require("dapui")
  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    -- Expand lines larger than the window
    -- Requires >= 0.7
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    -- Layouts define sections of the screen to place windows.
    -- The position can be "left", "right", "top" or "bottom".
    -- The size specifies the height/width depending on position. It can be an Int
    -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
    -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
    -- Elements are the elements shown in the layout (in order).
    -- Layouts are opened in order so that earlier layouts take priority in window sizing.
    layouts = {
      {
        elements = {
          -- Elements can be strings or table with id and size keys.
          "breakpoints",
          "stacks",
          "watches",
          { id = "scopes", size = 0.25 },
        },
        size = 40, -- 40 columns
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 0.25, -- 25% of total lines
        position = "bottom",
      },
    },
    controls = {
      -- Requires Neovim nightly (or 0.8 when released)
      enabled = true,
      -- Display controls in this element
      element = "repl",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "↻",
        terminate = "□",
      },
    },
    floating = {
      max_height = nil, -- These can be integers or a float between 0 and 1.
      max_width = nil, -- Floats will be treated as percentage of your screen.
      border = "single", -- Border style. Can be "single", "double" or "rounded"
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil, -- Can be integer or nil.
      max_value_lines = 100, -- Can be integer or nil.
    },
  })

  -- add dap-ui open and close to dap's callback
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
  end
end

return debugging
