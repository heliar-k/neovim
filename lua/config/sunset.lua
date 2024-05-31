local M = {}
function M.setup()
  require("sunset").setup({
    latitude = 30.16,           -- north is positive, south is negative
    longitude = 120.12,         -- east is positive, west is negative
    sunrise_offset = 0,         -- offset the sunrise by this many seconds
    sunset_offset = 0,          -- offset the sunset by this many seconds
    sunrise_override = "07:00", -- accepts a time in the form "HH:MM" which will override the sunrise time
    sunset_override = "17:00",  -- accepts a time in the form "HH:MM" which will override the sunset time
    day_callback = function()
      -- vim.cmd("colorscheme catppuccin-latte")
      -- vim.cmd("colorscheme github_light")
      -- require('onedark').setup {
      --   style = 'light'
      -- }
      -- require('onedark').load()
      vim.cmd("colorscheme nightfox")
    end, -- function that is called when day begins
    night_callback = function()
      -- vim.cmd("colorscheme catppuccin-macchiato")
      -- vim.cmd("colorscheme github_dark_dimmed")
      vim.cmd("colorscheme nightfox")
      -- require('onedark').setup {
      --   style = 'dark'
      -- }
      -- require('onedark').load()
    end,                     -- function that is called when night begins
    update_interval = 60000, -- how frequently to check for sunrise/sunset changes in milliseconds
    time_format = "%H:%M",   -- sun time formatting using os.date https://www.lua.org/pil/22.1.html
  })
end

return M
