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
-- windows 分屏快捷键
map("n", "sv", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt)
-- bufferline 左右Tab切换
map("n", "<C-h>", ":BufferLineCyclePrev<CR>", opt)
map("n", "<C-l>", ":BufferLineCycleNext<CR>", opt)
-- close-buffer
map("n", "bc", ":BDelete this<CR>", opt)  -- 关闭当前buffer页面
map("n", "bo", ":BDelete other<CR>", opt) -- 关闭除当前之外的所有buffer页面
-- nvimTree
map('n', 'nt', ':NvimTreeToggle<CR>', opt)

local M = {}

function M.setup()
  require("which-key").setup({})
  require("which-key").register({
    -- nvim-treesitter 代码格式化
        ['<F2>'] = { "gg=G" },
    -- debugging dap setting
        ["<F5>"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step into" },
        ["<F6>"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step over" },
        ["<F7>"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step out" },
        ["<F8>"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        ['s'] = {
      name = "Split Windows",
    },
        ["z"] = {
      name = "Folds",
      o = { "<cmd>foldopen<cr>", "Open fold" },
      c = { "<cmd>foldclose<cr>", "Close fold" },
      O = { "<cmd>lua require('ufo').openAllFolds<cr>", "Open all folds" },
      C = { "<cmd>lua require('ufo').closeAllFolds<cr>", "Close all folds" },
    },
        ["<leader>"] = {
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
        o = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
      },
      g = {
        name = "Git",
        o = { "<cmd>LazyGitCurrentFile<cr>", "Open Lazygit" },
      },
      l = {
        name = "LSP",
        a = { "<cmd>Lspsaga code_action<cr>", "Code actions" },
        d = { "<cmd>Trouble lsp_definitions<cr>", "Go to definition" },
        h = { "<cmd>ClangdSwitchSourceHeader<cr>", "Toggle header/source" },
        p = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" },
        u = { "<cmd>Trouble lsp_references<cr>", "Show usages" },
        r = { "<cmd>Lspsaga rename<cr>", "Rename" },
        x = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Show line diagnostics" },
      },
      s = {
        name = "Search",
        s = { ":lua require('searchbox').incsearch()<cr>", "Incremental search" },
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
