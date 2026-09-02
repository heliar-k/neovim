-- leader key 为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.api.nvim_set_keymap
local opt = {
  noremap = true,
  silent = true,
}

-- LSP peek 布局：居中小弹窗（列表 + 预览，类似 VSCode peek / lspsaga 浮窗）
-- 注意：自定义布局必须是 snacks.layout.Config 结构（layout 内再套 layout）
local PEEK_LAYOUT = {
  layout = {
    layout = {
      box = "vertical",
      width = 0.5,
      min_width = 60,
      height = 0.6,
      min_height = 10,
      border = "rounded",
      title = "{title} {live} {flags}",
      title_pos = "center",
      { win = "input", height = 1, border = "bottom" },
      { win = "list", border = "none" },
      { win = "preview", title = "{preview}", height = 0.5, border = "top" },
    },
  },
}
-- ctrl u / ctrl + d  只移动9行，默认移动半屏
map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)

local M = {}

function M.setup()
  local wk = require("which-key")
  wk.setup({
    preset = "modern",
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      presets = {
        operators = false, -- adds help for operators like d, y, ...
        motions = false, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = false, -- misc bindings to work with windows
        z = false, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
  })
  -- pi-coding-agent（终端 TUI + 桥接发送上下文）
  -- 兜底：pi 未打开时创建 snacks float 终端，然后切回原窗口，
  -- 保证 Pi* 命令读到的是源文件 buffer 而非终端 buffer
  local function ensure_pi()
    local curwin = vim.api.nvim_get_current_win()
    local buf = nil
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_valid(b)
        and vim.bo[b].buftype == "terminal"
        and (vim.api.nvim_buf_get_name(b):lower():match(":pi$") or vim.api.nvim_buf_get_name(b):lower():match(":pi%s"))
      then
        buf = b
        break
      end
    end
    if not buf or vim.fn.bufwinid(buf) == -1 then
      require("snacks").terminal.toggle("pi")
      vim.api.nvim_set_current_win(curwin)
    end
  end

  -- 包装 pi-nvim 的 prompt：只在真正发送（回车）时才确保 float 终端存在，
  -- 避免输入框弹出时终端就先出现
  local pi = require("pi-nvim")
  if not pi._pi_nvim_prompt_wrapped then
    local orig_prompt = pi.prompt
    pi.prompt = function(message, ...)
      if message and message ~= "" then
        ensure_pi()
      end
      return orig_prompt(message, ...)
    end
    pi._pi_nvim_prompt_wrapped = true
  end

  wk.add({
    {
      "<C-t>",
      function()
        require("snacks").terminal.toggle()
      end,
      desc = "Toggle Terminal",
    },
    -- debugging keybindings
    { "<F5>", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step into" },
    { "<F6>", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step over" },
    { "<F7>", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step out" },
    { "<F8>", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },

    { "z", group = "Folds" },
    { "zo", "<cmd>foldopen<cr>", desc = "Open fold" },
    { "zc", "<cmd>foldclose<cr>", desc = "Close fold" },
    { "zO", "<cmd>lua require('ufo').openAllFolds<cr>", desc = "Open all folds" },
    { "zC", "<cmd>lua require('ufo').closeAllFolds<cr>", desc = "Close all folds" },

    -- pi-coding-agent（终端 TUI + 桥接发送上下文）
    { "<leader>a", group = "AI/pi" },
    {
      "<leader>ap",
      function()
        require("snacks").terminal.toggle("pi")
      end,
      desc = "Open pi TUI",
    },
    {
      "<leader>ac",
      function()
        vim.cmd("Pi")
      end,
      desc = "Send prompt to pi",
    },
    {
      "<leader>as",
      function()
        vim.cmd("PiSendSelection")
      end,
      mode = "v",
      desc = "Send selection to pi",
    },
    {
      "<leader>ab",
      function()
        vim.cmd("PiSendFile")
      end,
      desc = "Send file to pi",
    },
    { "<leader>aP", "<cmd>PiPing<cr>", desc = "Ping pi session" },
    { "<leader>aS", "<cmd>PiSessions<cr>", desc = "List pi sessions" },

    { "<leader>b", group = "Buffer" },
    { "<leader>bc", "<cmd>BufferClose<cr>", desc = "Close Current Buffer" },
    { "<leader>bx", "<cmd>BufferCloseAllButCurrent<cr>", desc = "Close All But Current Buffer" },
    { "<leader>bd", "<cmd>BufferCloseAllButCurrentOrPinned<cr>", desc = "Close All But Current or Pinned Buffer" },
    { "<leader>bD", "<cmd>BufferCloseAll<cr>", desc = "Close All Buffers" },
    { "<leader>bp", "<cmd>BufferPick<cr>", desc = "Magic Buffer Pick" },
    { "<leader>bh", "<cmd>BufferPrevious<cr>", desc = "Go to Previous Buffer Tab" },
    { "<leader>bl", "<cmd>BufferNext<cr>", desc = "Go to Next Buffer Tab" },
    -- alias for buffer goto previous and next
    { "<M-h>", "<cmd>BufferPrevious<cr>", desc = "Move Buffer Left" },
    { "<M-l>", "<cmd>BufferNext<cr>", desc = "Move Buffer Right" },

    { "<leader>c", group = "CMake" },
    { "<leader>cb", "<cmd>wa<cr><cmd>CMakeBuild<cr>", desc = "Build" },
    { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "Generate" },
    { "<leader>cd", "<cmd>wa<cr><cmd>CMakeDebug<cr>", desc = "Debug" },
    { "<leader>cr", "<cmd>wa<cr><cmd>CMakeRun<cr>", desc = "Run" },
    { "<leader>cs", "<cmd>CMakeStop<cr>", desc = "Stop" },
    { "<leader>cT", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Select Launch Target" },
    { "<leader>cc", "<cmd>CMakeSelectConfigurePreset<cr>", desc = "Select Configure Preset" },
    { "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", desc = "Select Build Target" },
    { "<leader>cl", "!ln -sf build/Debug/compile_commands.json .<cr>", desc = "Link Compilation Database" },

    { "<leader>d", group = "Debug" },
    { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
    {
      "<leader>dl",
      "<cmd>lua require'dap.ext.vscode'.load_launchjs()<cr><cmd>lua require'dap'.continue()<cr>",
      desc = "Launch Debug Session",
    },
    {
      "<leader>dt",
      "<cmd>lua require'dap'.terminate()<cr><cmd>lua require'dapui'.close()<cr>",
      desc = "Terminate Debug Session",
    },

    { "<leader>f", group = "Finder" },
    {
      "<leader>ff",
      function()
        require("snacks").picker.files({ hidden = true })
      end,
      desc = "Find File",
    },
    {
      "<leader>fg",
      function()
        require("snacks").picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>fh",
      function()
        require("snacks").picker.recent()
      end,
      desc = "Recent File",
    },
    {
      "<C-p>",
      function()
        require("snacks").picker.files({ hidden = true })
      end,
      desc = "Find File",
    },
    -- git
    { "<leader>g", group = "Git" },
    { "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", desc = "Open Lazygit" },
    { "<leader>gb", "<cmd>ToggleBlameLine<cr>", desc = "Toggle Blame Line" },
    { "<leader>gd", "<cmd>CodeDiff HEAD<cr>", desc = "CodeDiff with Head" },
    -- session
    { "<leader>q", group = "Session" },
    {
      "<leader>ql",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>qS",
      function()
        require("persistence").select()
      end,
      desc = "Select Session",
    },
    -- lsp
    { "<leader>l", group = "LSP" },
    { "<leader>lf", "<cmd>Format<cr>", desc = "Format" },
    { "<leader>lt", "<cmd>FormatToggle<cr>", desc = "FormatToggle" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    { "<leader>lu", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Show References" },
    { "<leader>lx", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Show Line Diagnostics" },
    { "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Actions" },
    -- VSCode 风格：gd(F12) 直接跳转定义，gD(Alt+F12) peek 预览定义
    { "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go To Definition" },
    {
      "gD",
      function()
        require("snacks").picker.lsp_definitions(PEEK_LAYOUT)
      end,
      desc = "Peek Definition",
    },
    { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go To Definition" },
    {
      "<leader>lp",
      function()
        require("snacks").picker.lsp_definitions(PEEK_LAYOUT)
      end,
      desc = "Peek Definition",
    },
    { "<leader>lj", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Jump to Header/Source (CPP)" },
    { "<C-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go To Definition" },
    {
      "gR",
      function()
        require("snacks").picker.lsp_references(PEEK_LAYOUT)
      end,
      desc = "Peek References",
    },

    { "<leader>n", group = "Explore/Outline" },
    { "<leader>nt", "<cmd>Neotree<cr>", desc = "Toggle" },
    { "<leader>no", "<cmd>Outline<cr>", desc = "Toggle Outline" },

    -- markdown 渲染（render-markdown.nvim）
    { "<leader>m", group = "Markdown" },
    { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Render" },
    { "<leader>mp", "<cmd>RenderMarkdown preview<cr>", desc = "Preview in Split" },

    -- { "<leader>p", group = "Obsidian", hidden = true },
    -- { "<leader>po", "<cmd>ObsidianOpen<cr>", desc = "Open", hidden = true },
    -- { "<leader>pc", "<cmd>ObsidianCheck<cr>", desc = "Check", hidden = true },
    -- { "<leader>pf", "<cmd>ObsidianSearch<cr>", desc = "Search", hidden = true },

    -- { "<leader>r", group = "Rust" },
    -- { "<leader>ra", "<cmd>RustLsp codeAction<cr>", desc = "Code Action" },
    -- { "<leader>rd", "<cmd>RustLsp debuggables<cr>", desc = "Debuggables" },
    -- { "<leader>rr", "<cmd>RustLsp runnables<cr>", desc = "Runnables" },

    { "<leader>s", group = "Split Windows" },
    { "<leader>sh", "<cmd>sp<cr>", desc = "Split horizontal" },
    { "<leader>sv", "<cmd>vsp<cr>", desc = "Split vertical" },

    { "<leader>t", group = "Trouble" },
    { "<leader>tp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Jump to Prev Diagnostics" },
    { "<leader>tn", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Jump to Next Diagnostics" },
    {
      "<leader>tE",
      "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>",
      desc = "Jump to Prev Error",
    },
    {
      "<leader>te",
      "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>",
      desc = "Jump to Next Error",
    },
    -- theme switch
    {
      "<leader>td",
      function()
        require("config.theme").set_dark()
      end,
      desc = "Switch Dark mode",
    },
    {
      "<leader>tl",
      function()
        require("config.theme").set_light()
      end,
      desc = "Switch Light mode",
    },

    -- python virtualenv selector
    { "<leader>v", group = "Python Venv Selector" },
    { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "open VenvSelector to pick a venv" },
  })
end

return M
