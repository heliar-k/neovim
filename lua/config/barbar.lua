vim.g.barbar_auto_setup = false -- disable auto setup

local M = {}
function M.setup()
  require("barbar").setup({
    animation = true,
    separator_at_end = false,
    exclude_ft = { "neo-tree", "outline", "alpha" },
    sidebar_filetypes = {
      ["neo-tree"] = { event = "BufWipeout", align = "left" },
      ["Outline"] = { event = "BufWinLeave", text = "symbols-outline", align = "right" },
    },
  })
end

return M
