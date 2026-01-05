-- leader key 为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.api.nvim_set_keymap
local opt = {
  noremap = true,
  silent = true,
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
  wk.add({
    { "<C-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
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

    { "<leader>a", group = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },

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

    { "<leader>f", group = "Telescope" },
    { "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find File" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    { "<leader>fh", "<cmd>Telescope oldfiles<cr>", desc = "Recent File" },
    { "<C-p>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find File" },
    -- git
    { "<leader>g", group = "Git" },
    { "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", desc = "Open Lazygit" },
    { "<leader>gb", "<cmd>ToggleBlameLine<cr>", desc = "Toggle Blame Line" },
    -- lsp
    { "<leader>l", group = "LSP" },
    { "<leader>lf", "<cmd>Format<cr>", desc = "Format" },
    { "<leader>lt", "<cmd>FormatToggle<cr>", desc = "FormatToggle" },
    { "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
    { "<leader>lu", "<cmd>Lspsaga finder def+ref<cr>", desc = "Show References" },
    { "<leader>lx", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Show Line Diagnostics" },
    { "<leader>lc", "<cmd>Lspsaga code_action<cr>", desc = "Code Actions" },
    { "<leader>ld", "<cmd>Lspsaga goto_definitions<cr>", desc = "Go To Definiton" },
    { "<leader>lp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
    { "<leader>lj", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Jump to Header/Source (CPP)" },
    { "<C-]>", "<cmd>Lspsaga finder def+ref<cr>", desc = "Show References" },

    { "<leader>n", group = "Explore/Outline" },
    { "<leader>nt", "<cmd>Neotree<cr>", desc = "Toggle" },
    { "<leader>no", "<cmd>Lspsaga outline<cr>", desc = "Toggle Outline" },

    -- opencode.nvim
    { "<leader>o", group = "Opencode" },
    {
      "<leader>oa",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      desc = "Ask opencode",
      mode = { "n", "x" },
    },
    {
      "<leader>ot",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle opencode",
      mode = { "n", "t" },
    },
    {
      "<leader>ox",
      function()
        require("opencode").select()
      end,
      desc = "Execute opencode action…",
      mode = { "n", "x" },
    },
    {
      "<leader>og",
      function()
        return require("opencode").operator("@this ")
      end,
      desc = "Add range to opencode",
      mode = { "n", "x" },
      expr = true,
    },
    {
      "<leader>ogo",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      desc = "Add line to opencode",
      mode = "n",
      expr = true,
    },
    {
      "<S-C-u>",
      function()
        require("opencode").command("session.half.page.up")
      end,
      desc = "opencode half page up",
      mode = "n",
    },
    {
      "<S-C-d>",
      function()
        require("opencode").command("session.half.page.down")
      end,
      desc = "opencode half page down",
      mode = "n",
    },

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
    { "<leader>tp", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Jump to Prev Diagnostics" },
    { "<leader>tn", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Jump to Next Diagnostics" },
    {
      "<leader>tE",
      "<cmd>lua require('lspsaga.diagnostic'):goto_prec({ severity = vim.diagnostic.severity.ERROR })<cr>",
      desc = "Jump to Prev Error",
    },
    {
      "<leader>te",
      "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>",
      desc = "Jump to Next Error",
    },
    -- python virtualenv selector
    { "<leader>v", group = "Python Venv Selector" },
    { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "open VenvSelector to pick a venv" },
  })
end

return M
