-- 需要安装的 parser 列表
local parsers = {
  "cpp",
  "python",
  "vim",
  "vimdoc",
  "lua",
  "bash",
  "cmake",
  "json",
  "yaml",
  "toml",
  "rust",
  "ron",
  "markdown",
  "markdown_inline",
}

-- 初始化 nvim-treesitter
require("nvim-treesitter").setup()

-- 安装 parser（已安装的会自动跳过）
require("nvim-treesitter").install(parsers)

-- 通过 FileType autocommand 启用高亮和缩进
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
  callback = function(args)
    -- 检查当前 filetype 是否有可用的 parser
    local ok = pcall(vim.treesitter.start, args.buf)
    if ok then
      -- 启用基于 Treesitter 的缩进
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- 开启 Folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.wo.foldlevel = 99
