-- leader key 为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.api.nvim_set_keymap
local opt = {
  noremap = true,
  silent = true
}
-- ctrl u / ctrl + d  只移动9行，默认移动半屏
map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)
-- bufferline 左右Tab切换
map("n", "<C-h>", ":BufferLineCyclePrev<CR>", opt)
map("n", "<C-l>", ":BufferLineCycleNext<CR>", opt)

local M = {}

function M.setup()
  require("which-key").setup({
    plugins = {
      marks = true,     -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      presets = {
        operators = false,   -- adds help for operators like d, y, ...
        motions = false,     -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true,      -- default bindings on <c-w>
        nav = false,         -- misc bindings to work with windows
        z = false,           -- bindings for folds, spelling and others prefixed with z
        g = true,            -- bindings for prefixed with g
      },
    },
  })
  require("which-key").register({
    -- debugging dap setting
    ["<F5>"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step into" },
    ["<F6>"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step over" },
    ["<F7>"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step out" },
    ["<F8>"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    ["<c-\\>"] = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
    ['s'] = {
      name = "Split Windows",
      h = { "<cmd>sp<cr>", "Split horizontal" },
      v = { "<cmd>vsp<cr>", "Split vertical" },
    },
    ["z"] = {
      name = "Folds",
      o = { "<cmd>foldopen<cr>", "Open fold" },
      c = { "<cmd>foldclose<cr>", "Close fold" },
      O = { "<cmd>lua require('ufo').openAllFolds<cr>", "Open all folds" },
      C = { "<cmd>lua require('ufo').closeAllFolds<cr>", "Close all folds" },
    },
    ["<leader>"] = {
      b = {
        name = "Close Buffer",
        c = { "<cmd>BDelete this<cr>", "Close Current Buffer" },
        o = { "<cmd>BDelete other<cr>", "Close Other Buffer" }
      },
      c = {
        name = "CMake",
        l = { "!ln -sf build/Debug/compile_commands.json .<cr>", "Link compilation database" },
        c = { "<cmd>CMakeSelectConfigurePreset<cr>", "Select configure preset" },
        g = { "<cmd>CMakeGenerate<cr>", "Generate" },
        t = { "<cmd>CMakeSelectBuildTarget<cr>", "Select build target" },
        b = { "<cmd>wa<cr><cmd>CMakeBuild<cr>", "Build" },
        T = { "<cmd>CMakeSelectLaunchTarget<cr>", "Select launch target" },
        r = { "<cmd>wa<cr><cmd>CMakeRun<cr>", "Run" },
        d = { "<cmd>wa<cr><cmd>CMakeDebug<cr>", "Debug" },
        s = { "<cmd>CMakeStop<cr>", "Stop" },
      },
      d = {
        name = "Debug",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
        l = {
          "<cmd>lua require'dap.ext.vscode'.load_launchjs()<cr><cmd>lua require'dap'.continue()<cr>",
          "Launch debug session",
        },
        t = { "<cmd>lua require'dap'.terminate()<cr><cmd>lua require'dapui'.close()<cr>", "Terminate debug session" },
      },
      f = {
        name = "Fuzzy finder",
        f = { "<cmd>Telescope find_files hidden=true<cr>", "Find files" },
        g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
      },
      g = {
        name = "Git",
        g = { "<cmd>LazyGitCurrentFile<cr>", "Open Lazygit" },
      },
      l = {
        name = "LSP",
        a = { "<cmd>Lspsaga code_action<cr>", "Code actions" },
        d = { "<cmd>Trouble lsp_definitions<cr>", "Go to definition" },
        f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
        n = { "<cmd>lua require'config.null-ls.formatters'.toggle()<cr>", "Toggle autoformat on save" },
        h = { "<cmd>ClangdSwitchSourceHeader<cr>", "Toggle header/source" },
        p = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" },
        u = { "<cmd>Trouble lsp_references<cr>", "Show usages" },
        r = { "<cmd>Lspsaga rename<cr>", "Rename" },
        x = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Show line diagnostics" },
      },
      n = {
        name = "FileExplore",
        t = { "<cmd>Neotree<cr>", "Toggle" },
      },
      o = {
        name = "Symbols Outline",
        c = { "<cmd>SymbolsOutlineClose<cr>", "Close" },
        o = { "<cmd>SymbolsOutlineOpen<cr>", "Open" },
        t = { "<cmd>SymbolsOutline<cr>", "Toggle" },
      },
      p = {
        name = "Obsidian",
        o = { "<cmd>ObsidianOpen<cr>", "Open" },
        c = { "<cmd>ObsidianCheck<cr>", "Check" },
        f = { "<cmd>ObsidianSearch<cr>", "Search" },
      },
      s = {
        name = "Search",
        i = { ":lua require('searchbox').incsearch()<cr>", "Incremental search" },
        a = { ":lua require('searchbox').match_all()<cr>", "Match all" },
        r = { ":lua require('searchbox').replace()<cr>", "Replace" },
      },
      x = {
        name = "Trouble",
        d = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnostics" },
        q = { "<cmd>Trouble quickfix<cr>", "Quickfix" },
        n = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Jump to next diagnostic" },
        p = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Jump to next diagnostic" },
        e = {
          "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>",
          "Jump to next error",
        },
        E = {
          "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>",
          "Jump to previous error",
        },
      },
    },
  })
end

return M
