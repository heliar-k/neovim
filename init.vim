" 编辑器设置
lua require('editor')

" 快捷键映射
lua require('keybindings')

" Packer插件管理
lua require('plugin')

" 主题
"colorscheme nightfox
colorscheme dracula

" yank hightlight
augroup highlight_yank
   autocmd!
   au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

