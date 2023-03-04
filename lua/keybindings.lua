-- leader key 为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local M = {}

function M.setup()
  require("which-key").setup({})
  require("which-key").register({
    -- ctrl u / ctrl + d  只移动9行，默认移动半屏
        ['<C-u>'] = { "9k", mode = "n" },
        ['<C-d>'] = { "9j", mode = "n" },
    -- visual模式下缩进代码
        ['<'] = { "<gv", mode = "v" },
        ['>'] = { ">gv", mode = "v" },
    -- windows 分屏快捷键
        ['sv'] = { ":vsp<CR>", mode = "n" },
        ['sh'] = { ":sp<CR>", mode = "n" },
    -- buffer 管理
    -- bufferline 左右Tab切换
        ['<C-h>'] = { ":BufferLineCyclePrev<CR>", mode = "n" },
        ['<C-l>'] = { ":BufferLineCycleNext<CR>", mode = "n" },
    -- close-buffer
        ['bc'] = { ":BDelete this<CR>", mode = "n" },  -- 关闭当前buffer页面
        ['bo'] = { ":BDelete other<CR>", mode = "n" }, -- 关闭除当前之外的所有buffer页面
    -- nvim-treesitter 代码格式化
        ['<F2>'] = { "gg=G", mode = "n" },
    -- debugging dap setting
        ["<F5>"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step into" },
        ["<F6>"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step over" },
        ["<F7>"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step out" },
        ["<F8>"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
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
      n = { name = "Nvim Tree", t = { "<cmd>NvimTreeToggle<cr>", "Toggle" } },
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
