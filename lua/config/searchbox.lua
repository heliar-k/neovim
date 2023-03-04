local M = {}

function M.setup()
  require("searchbox").setup({
    defaults = {
      reverse = false,
      exact = false,
      prompt = " ",
      modifier = "disabled",
      confirm = "menu",
      clear_matches = true,
      show_matches = false,
    },
    popup = {
      relative = "win",
      position = {
        row = "5%",
        col = "95%",
      },
      size = 30,
      border = {
        style = "rounded",
        text = {
          top = " Search ",
          top_align = "left",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    },
    hooks = {
      before_mount = function(input)
        -- code
      end,
      after_mount = function(input)
        -- code
      end,
      on_done = function(value, search_type)
        -- code
      end,
    },
  })
end

return M
