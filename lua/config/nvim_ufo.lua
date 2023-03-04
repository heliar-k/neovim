local M = {}

function M.setup()
  vim.o.foldcolumn = "1"
  vim.o.foldnestmax = "0"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
  vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

  -- Option 3: treesitter as a main provider instead
  -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
  -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
  require("ufo").setup({
    provider_selector = function(bufnr, filetype, buftype)
      return { "treesitter", "indent" }
    end,
  })
end

return M
