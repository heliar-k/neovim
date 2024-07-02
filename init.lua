-- yank hightlight
vim.cmd [[
augroup highlight_yank
   autocmd!
   au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=600}
augroup END
]]

-- 编辑器设置
require('editor')

if not vim.g.vscode then
  -- vscode will not load the plugin
  -- 插件设置
  require('plugin')
  -- 快捷键映射
  require('keybindings').setup()
end
