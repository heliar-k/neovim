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
