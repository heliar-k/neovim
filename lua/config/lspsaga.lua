local M = {}

function M.setup()
  require("lspsaga").setup({
    ui = {
      kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
      colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
    },
    symbol_in_winbar = {
      enable = false,
      separator = " ",
      hide_keyword = true,
      show_file = true,
      folder_level = 2,
    },
  })
end

return M
