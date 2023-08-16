local M = {}
function M.setup()
  require("sunset").setup({
    latitude = 29.11,           -- north is positive, south is negative
    longitude = -118.20,        -- east is positive, west is negative
    sunrise_offset = 0,         -- offset the sunrise by this many seconds
    sunset_offset = 0,          -- offset the sunset by this many seconds
    sunrise_override = "07:00", -- accepts a time in the form "HH:MM" which will override the sunrise time
    sunset_override = "18:00",  -- accepts a time in the form "HH:MM" which will override the sunset time
    day_callback = function()
      vim.cmd("colorscheme catppuccin-latte")
    end, -- function that is called when day begins
    night_callback = function()
      vim.cmd("colorscheme catppuccin-frappe")
    end,                     -- function that is called when night begins
    update_interval = 60000, -- how frequently to check for sunrise/sunset changes in milliseconds
    time_format = "%H:%M",   -- sun time formatting using os.date https://www.lua.org/pil/22.1.html
  })
end

return M
