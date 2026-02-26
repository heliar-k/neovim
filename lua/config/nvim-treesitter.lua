-- 确保 tree-sitter CLI 已安装（main 分支编译 parser 需要）
if vim.fn.executable("tree-sitter") ~= 1 then
  local installed = false
  if vim.fn.executable("brew") == 1 then
    vim.notify("tree-sitter CLI 未找到，正在通过 brew 安装...", vim.log.levels.INFO)
    local r = vim.fn.system("brew install tree-sitter tree-sitter-cli")
    installed = vim.v.shell_error == 0
    if not installed then
      vim.notify("brew 安装 tree-sitter-cli 失败: " .. r, vim.log.levels.WARN)
    end
  end
  if not installed and vim.fn.executable("cargo") == 1 then
    vim.notify("tree-sitter CLI 未找到，正在通过 cargo 安装...", vim.log.levels.INFO)
    local r = vim.fn.system("cargo install tree-sitter-cli")
    installed = vim.v.shell_error == 0
    if not installed then
      vim.notify("cargo 安装 tree-sitter-cli 失败: " .. r, vim.log.levels.WARN)
    end
  end
  if not installed then
    vim.notify(
      "tree-sitter CLI 未安装，请手动执行: brew install tree-sitter-cli 或 cargo install tree-sitter-cli",
      vim.log.levels.ERROR
    )
  end
end

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
