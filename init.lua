-- 自动安装lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- 编辑器设置
require('editor')

-- 快捷键映射
require('keybindings')

-- 插件设置
require('plugin')

vim.cmd [[colorscheme catppuccin-latte]]

-- yank hightlight
vim.cmd [[
augroup highlight_yank
   autocmd!
   au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=600}
augroup END
]]
