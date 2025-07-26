local M = {}

function M.setup()
  local conform = require("conform")
  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      rust = { "rustfmt" },
      toml = { "taplo" },
      json = { "prettierd", "prettier", stop_after_first = true },
      javascript = { "prettierd", stop_after_first = true },
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ["_"] = { "trim_whitespace" },
    },
    -- format_on_save setting
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  })
  -- create Format Command
  vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
  end, { range = true })
  -- create Format Toggle Command
  vim.api.nvim_create_user_command("FormatToggle", function()
    if vim.b.disable_autoformat or vim.g.disable_autoformat then
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      print("Autoformat on save enabled")
    else
      vim.b.disable_autoformat = true
      vim.g.disable_autoformat = true
      print("Autoformat on save disabled")
    end
  end, {
    desc = "Toggle autoformat-on-save",
  })
end

return M
