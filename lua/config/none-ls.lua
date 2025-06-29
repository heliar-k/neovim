local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black.with({
      extra_args = { "--line-length", "88" },
    }),
    null_ls.builtins.formatting.isort.with({
      extra_args = { "--profile", "black" },
    }),
  },
})
