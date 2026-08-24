local M = {}

function M.setup()
  require("blink.cmp").setup({
    keymap = {
      preset = "default",
      -- 沿用原 nvim-cmp 的习惯：Tab 选择、CR 只确认显式选中的项
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next" },
      ["<C-k>"] = { "select_prev" },
      ["<A-.>"] = { "show" },
      ["<A-,>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    sources = {
      default = { "lsp", "path", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 50,
          async = true,
        },
      },
    },
    cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      sources = { default = { "cmdline", "path" } },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
  })
end

return M
