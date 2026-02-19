# Neovim 配置

一个基于 Lua 配置的现代 Neovim 编辑器，使用 lazy.nvim 进行插件管理。

## 特性

- **插件管理**: 使用 lazy.nvim 实现高效的插件加载
- **代码格式化**: conform.nvim + stylua 支持保存时自动格式化
- **LSP 支持**: 通过 lspconfig 和 mason.nvim 提供强大的语言服务器支持
- **模糊搜索**: Telescope 集成，支持文件搜索、grep、内容搜索等
- **语法高亮**: Treesitter 提供精确的语法高亮
- **UI 增强**: 状态栏、文件浏览器、书签等多功能插件

## 目录结构

```
~/.config/nvim/
├── init.lua              -- 入口文件
├── AGENTS.md             -- Agent 开发指南
├── .stylua.toml          -- stylua 格式化配置
├── lua/
│   ├── plugin.lua        -- 插件列表和 lazy.nvim 配置
│   ├── editor.lua        -- 编辑器基础设置
│   ├── keybindings.lua  -- 快捷键映射
│   ├── config/           -- 插件配置
│   │   ├── lsp.lua       -- LSP 配置
│   │   ├── telescope.lua -- Telescope 配置
│   │   └── ...
│   └── utils/            -- 工具函数
└── ...
```

## 插件列表

### 核心插件
- [lazy.nvim](https://github.com/folke/lazy.nvim) - 插件管理器
- [conform.nvim](https://github.com/stevearc/conform.nvim) - 代码格式化
- [vimloader.nvim](https://github.com/rafi/vimloader.nvim) - 启动加载器

### LSP 和补全
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP 服务器管理
- [lspconfig.nvim](https://github.com/neovim/nvim-lspconfig) - LSP 客户端配置
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - 代码补全

### UI 和外观
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 语法高亮
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - 模糊搜索
- [which-key.nvim](https://github.com/folke/which-key.nvim) - 快捷键提示
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) - 文件图标
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - 状态栏
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) -- 缓冲区标签页

### 工具插件
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git 状态显示
- [vim-surround](https://github.com/tpope/vim-surround) - 环绕编辑
- [vim-repeat](https://github.com/tpope/vim-repeat) - 重复操作增强
- [ Commentary.nvim](https://github.com/tpope/vim-commentary) - 注释工具

## 安装

1. 备份现有配置（如果有）:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. 克隆配置:
   ```bash
   git clone https://github.com/your-repo/nvim-config.git ~/.config/nvim
   ```

3. 启动 Neovim:
   ```bash
   nvim
   ```

4. lazy.nvim 会自动安装所有插件（首次启动可能需要几分钟）

## 快捷键

### 通用

| 快捷键 | 说明 |
|--------|------|
| `<Space>` | leader 键 |
| `<Esc>` | 退出当前模式 |
| `jj` | 快速退出插入模式 |

### 文件操作

| 快捷键 | 说明 |
|--------|------|
| `<leader>ff` | 查找文件 (Telescope) |
| `<leader>fg` | 搜索内容 (Telescope grep) |
| `<leader>fb` | 搜索缓冲区 (Telescope buffers) |
| `<leader>fh` | 搜索帮助文档 (Telescope help) |
| `<leader>fr` | 打开最近文件 (Telescope recent) |

### Git 操作

| 快捷键 | 说明 |
|--------|------|
| `<leader>gg` | 打开lazygit |
| `]c` | 下一个 git hunk |
| `[c` | 上一个 git hunk |
| `<leader>hs` | stage hunk |
| `<leader>hr` | reset hunk |

### 窗口操作

| 快捷键 | 说明 |
|--------|------|
| `<leader>sv` | 垂直分屏 |
| `<leader>sh` | 水平分屏 |
| `<leader>sc` | 关闭当前窗口 |
| `<leader>so` | 关闭其他窗口 |

### LSP 操作

| 快捷键 | 说明 |
|--------|------|
| `gd` | 跳转定义 |
| `gD` | 跳转声明 |
| `gr` | 查找引用 |
| `K` | 显示 hover 文档 |
| `<leader>rn` | 重命名 |
| `<leader>ca` | 代码操作 |

### Treesitter 操作

| 快捷键 | 说明 |
|--------|------|
| `]m` | 下一个函数 |
| `[m` | 上一个函数 |
| `]M` | 下一个类/模块 |
| `[M` | 上一个类/模块 |

## 自定义配置

### 添加新插件

在 `lua/plugin.lua` 中添加插件配置:

```lua
{
  "author/plugin-name",
  event = "BufReadPre",
  dependencies = { "dependency-plugin" },
  config = function()
    require("config.plugin_name").setup()
  end,
},
```

然后创建对应的配置文件 `lua/config/plugin_name.lua`:

```lua
local M = {}

M.setup = function()
  require("plugin_name").setup({
    -- your options
  })
end

return M
```

### 修改格式化配置

在 `lua/config/conform.lua` 中添加或修改格式化器:

```lua
local formatters = require("conform.formatters")
formatters.precedence = {
  "stylua",
  "prettier",
  -- 添加更多格式化器
}
```

## 格式化

项目使用 stylua 进行 Lua 代码格式化:

```bash
# 格式化所有文件
stylua lua/

# 检查格式化（不修改）
stylua --check lua/
```

## 常见问题

### 插件安装失败

确保网络畅通，可以尝试:
```vim
:Lazy repair
```

### LSP 服务器无法启动

检查 mason.nvim 安装的服务器:
```vim
:Mason
```

手动安装服务器:
```vim
:MasonInstall <server-name>
```

### 格式化不生效

检查 conform.nvim 配置:
```vim
:ConformInfo
```

## 更新

### 更新插件

```vim
:Lazy update
```

### 更新配置

```bash
git pull
:Lazy sync
```

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License
