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
    {
      "<C-\\>",
      "<cmd>ToggleTerm<cr>",
      desc = "Toggle Terminal",
    },
    -- debugging keybindings
    {
      "<F5>",
      "<cmd>lua require'dap'.step_into()<cr>",
      desc = "Step into",
    },
    {
      "<F6>",
      "<cmd>lua require'dap'.step_over()<cr>",
      desc = "Step over",
    },
    {
      "<F7>",
      "<cmd>lua require'dap'.step_out()<cr>",
      desc = "Step out",
    },
    {
      "<F8>",
      "<cmd>lua require'dap'.continue()<cr>",
      desc = "Continue",
    },
    -- buffer tab switch
    {
      "<C-h>",
      "<cmd>BufferLineCyclePrev<cr>",
      desc = "Go to Previous Buffer Tab",
    },
    {
      "<C-l>",
      "<cmd>BufferLineCycleNext<cr>",
      desc = "Go to Next Buffer Tab",
    },

    { "z", group = "Folds" },
    {
      "zo",
      "<cmd>foldopen<cr>",
      desc = "Open fold",
    },
    {
      "zc",
      "<cmd>foldclose<cr>",
      desc = "Close fold",
    },
    {
      "zO",
      "<cmd>lua require('ufo').openAllFolds<cr>",
      desc = "Open all folds",
    },
    {
      "zC",
      "<cmd>lua require('ufo').closeAllFolds<cr>",
      desc = "Close all folds",
    },

    { "<leader>b", group = "CloseBuffer" },
    {
      "<leader>bc",
      "<cmd>BDelete this<cr>",
      desc = "Close Current Buffer",
    },
    {
      "<leader>bo",
      "<cmd>BDelete other<cr>",
      desc = "Close Other Buffer",
    },

    { "<leader>c", group = "CMake" },
    {
      "<leader>cb",
      "<cmd>wa<cr><cmd>CMakeBuild<cr>",
      desc = "Build",
    },
    {
      "<leader>cg",
      "<cmd>CMakeGenerate<cr>",
      desc = "Generate",
    },
    {
      "<leader>cd",
      "<cmd>wa<cr><cmd>CMakeDebug<cr>",
      desc = "Debug",
    },
    {
      "<leader>cr",
      "<cmd>wa<cr><cmd>CMakeRun<cr>",
      desc = "Run",
    },
    {
      "<leader>cs",
      "<cmd>CMakeStop<cr>",
      desc = "Stop",
    },
    {
      "<leader>cT",
      "<cmd>CMakeSelectLaunchTarget<cr>",
      desc = "Select Launch Target",
    },
    {
      "<leader>cc",
      "<cmd>CMakeSelectConfigurePreset<cr>",
      desc = "Select Configure Preset",
    },
    {
      "<leader>ct",
      "<cmd>CMakeSelectBuildTarget<cr>",
      desc = "Select Build Target",
    },
    {
      "<leader>cl",
      "!ln -sf build/Debug/compile_commands.json .<cr>",
      desc = "Link Compilation Database",
    },

    { "<leader>d", group = "Debug" },
    {
      "<leader>db",
      "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
      desc = "Toggle Breakpoint",
    },
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
    {
      "<leader>ff",
      "<cmd>Telescope find_files hidden=true<cr>",
      desc = "Find File",
    },
    {
      "<leader>fg",
      "<cmd>Telescope live_grep<cr>",
      desc = "Grep",
    },
    {
      "<leader>fh",
      "<cmd>Telescope oldfiles<cr>",
      desc = "Recent File",
    },
    -- git
    { "<leader>g", group = "Git" },
    {
      "<leader>gg",
      "<cmd>LazyGitCurrentFile<cr>",
      desc = "Open Lazygit",
    },
    -- lsp
    { "<leader>l", group = "LSP" },
    {
      "<leader>lf",
      "<cmd>lua vim.lsp.buf.format()<cr>",
      desc = "Format Opened File",
    },
    {
      "<leader>lt",
      "<cmd>lua require'config.null-ls.formatters'.toggle()<cr>",
      desc = "Toggle Auto Format on Save",
    },
    {
      "<leader>lr",
      "<cmd>Lspsaga rename<cr>",
      desc = "Rename",
    },
    {
      "<leader>lu",
      "<cmd>Trouble lsp_references<cr>",
      desc = "Show References",
    },
    {
      "<leader>lx",
      "<cmd>Lspsaga show_line_diagnostics<cr>",
      desc = "Show Line Diagnostics",
    },
    {
      "<leader>lc",
      "<cmd>Lspsaga code_action<cr>",
      desc = "Code Actions",
    },
    {
      "<leader>ld",
      "<cmd>Trouble lsp_definitions<cr>",
      desc = "Go To Definiton",
    },
    {
      "<leader>lp",
      "<cmd>Lspsaga peek_definition<cr>",
      desc = "Peek definition",
    },
    {
      "<leader>lj",
      "<cmd>ClangdSwitchSourceHeader<cr>",
      desc = "Jump to Header/Source (CPP)",
    },

    { "<leader>n", group = "Explore" },
    {
      "<leader>nt",
      "<cmd>Neotree<cr>",
      desc = "Toggle",
    },

    { "<leader>r", group = "Rust" },
    {
      "<leader>ra",
      "<cmd>lua require'rust-tools'.code_action_group.code_action_group()<cr>",
      desc = "Code actions",
    },
    {
      "<leader>rh",
      "<cmd>lua require'rust-tools'.hover_actions.hover_actions()<cr>",
      desc = "Hover actions",
    },
    {
      "<leader>rr",
      "<cmd>wa<cr><cmd>lua require'rust-tools'.runnables.runnables()<cr>",
      desc = "Runnables",
    },
    {
      "<leader>rd",
      "<cmd>wa<cr><cmd>lua require'rust-tools'.debuggables.debuggables()<cr>",
      desc = "Debuggables",
    },


    { "<leader>o", group = "Outline" },
    {
      "<leader>ot",
      "<cmd>Outline<cr>",
      desc = "Toggle Outline",
    },

    -- { "<leader>p",   group = "Obsidian",                                                                         hidden = true },
    -- { "<leader>po",  "<cmd>ObsidianOpen<cr>",                                                                    desc = "Open",                       hidden = true },
    -- { "<leader>pc",  "<cmd>ObsidianCheck<cr>",                                                                   desc = "Check",                      hidden = true },
    -- { "<leader>pf",  "<cmd>ObsidianSearch<cr>",                                                                  desc = "Search",                     hidden = true },

    { "<leader>s", group = "Split Windows" },
    {
      "<leader>sh",
      "<cmd>sp<cr>",
      desc = "Split horizontal",
    },
    {
      "<leader>sv",
      "<cmd>vsp<cr>",
      desc = "Split vertical",
    },

    { "<leader>t", group = "Trouble" },
    {
      "<leader>td",
      "<cmd>Trouble workspace_diagnostics<cr>",
      desc = "Diagnostics Workspace",
    },
    {
      "<leader>tq",
      "<cmd>Trouble quickfix<cr>",
      desc = "Quickfix",
    },
    {
      "<leader>tp",
      "<cmd>Lspsaga diagnostic_jump_prev<cr>",
      desc = "Jump to Prev Diagnostics",
    },
    {
      "<leader>tn",
      "<cmd>Lspsaga diagnostic_jump_next<cr>",
      desc = "Jump to Next Diagnostics",
    },
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
  })
end

return M
