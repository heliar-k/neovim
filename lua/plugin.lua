-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv
  ---@diagnostic disable-next-line: deprecated
  or vim.loop
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

local have_make = vim.fn.executable("make") == 1
local have_cmake = vim.fn.executable("cmake") == 1

vim.opt.rtp:prepend(lazypath)

return require("lazy").setup(
  {
    rocks = { hererocks = true },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = function()
        return vim.tbl_deep_extend("force", {
          input = { enabled = true },
          notifier = { enabled = true },
          picker = { enabled = true },
          image = { enabled = false },
          explorer = { enabled = false },
          terminal = {
            win = { position = "bottom", height = 15 },
          },
        }, require("config.dashboard"))
      end,
    },
    {
      "williamboman/mason.nvim",
      config = function()
        require("config.mason")
      end,
      lazy = false,
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      dependencies = {
        "williamboman/mason.nvim",
      },
    },
    ----------------------------- lsp -----------------------------
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("config.lsp").setup()
      end,
    },
    {
      "ray-x/lsp_signature.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
      },
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
      },
    },
    {
      "j-hui/fidget.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      tag = "legacy",
      event = "LspAttach",
      config = function()
        require("fidget").setup()
      end,
    },
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo", "Format", "FormatEnable", "FormatDisable" },
      config = function()
        require("config.conform").setup()
      end,
      lazy = false,
    },
    -- none-ls
    {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "jay-babu/mason-null-ls.nvim",
        "nvimtools/none-ls-extras.nvim",
      },
      config = function()
        -- require("config.none-ls").setup()
      end,
    },
    -- Displaying errors/warnings in a window
    {
      "folke/trouble.nvim",
      lazy = true,
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("trouble").setup({})
      end,
    },
    -- session manager（persistence：退出自动保存，不按 cwd 自动恢复）
    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      opts = {},
    },

    ----------------------------- ui -----------------------------
    -- themes
    { "projekt0n/github-nvim-theme", lazy = false, priority = 1000, name = "github" },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, name = "tokyonight" },
    -- auto dark mode (via terminal OSC 11)
    {
      "afonsofrancof/OSC11.nvim",
      opts = {
        on_dark = function()
          require("config.theme").set_dark()
        end,
        on_light = function()
          require("config.theme").set_light()
        end,
      },
      config = function(_, opts)
        require("osc11").setup(opts)

        -- Pure-Lua OSC 11 background probe: sends query to terminal,
        -- listens for TermResponse, no external script needed.
        local function osc11_detect(timeout)
          timeout = timeout or 300
          local done = false
          local theme = "dark"
          local timer = vim.uv.new_timer()
          local augroup = vim.api.nvim_create_augroup("_Osc11Detect", { clear = true })

          vim.api.nvim_create_autocmd("TermResponse", {
            group = augroup,
            once = true,
            callback = function()
              if done then
                return
              end
              local r, g, b = (vim.v.termresponse or ""):match("rgb:(%x+)/(%x+)/(%x+)")
              if r then
                r, g, b = tonumber(r, 16) or 255, tonumber(g, 16) or 255, tonumber(b, 16) or 255
                if r > 255 then
                  r = math.floor(r / 256)
                end
                if g > 255 then
                  g = math.floor(g / 256)
                end
                if b > 255 then
                  b = math.floor(b / 256)
                end
                theme = ((299 * r + 587 * g + 114 * b) / 1000) < 128 and "dark" or "light"
              end
              done = true
              timer:stop()
              timer:close()
              pcall(vim.api.nvim_del_augroup_by_id, augroup)
            end,
          })

          timer:start(timeout, 0, function()
            if not done then
              done = true
              pcall(vim.api.nvim_del_augroup_by_id, augroup)
            end
            timer:close()
          end)

          io.stdout:write("\27]11;?\27\\")
          io.stdout:flush()
          vim.wait(timeout + 50, function()
            return done
          end)
          return theme
        end

        -- Active probe: OSC11.nvim is passive (listens for TermResponse only).
        -- If Neovim's auto-query races with plugin load (common on SSH/tmux),
        -- the passive listener never fires. Send our own query as fallback.
        vim.api.nvim_create_autocmd("VimEnter", {
          once = true,
          callback = function()
            if vim.g.colors_name then
              return
            end
            local theme = require("config.theme")
            if osc11_detect(300) == "light" then
              theme.set_light()
            else
              theme.set_dark()
            end
          end,
        })
      end,
    },
    -- line in the bottom
    {
      "nvim-tree/nvim-web-devicons",
      lazy = false,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("config.lualine")
      end,
    },
    {
      "shellRaining/hlchunk.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("hlchunk").setup({
          chunk = {
            enable = true,
            duration = 100,
            delay = 300,
          },
          indent = {
            enable = true,
          },
        })
      end,
    },
    -- barbar
    {
      "romgrk/barbar.nvim",
      dependencies = {
        "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
        "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
      },
      config = function()
        require("config.barbar").setup()
      end,
    },
    {
      "kazhala/close-buffers.nvim",
    },
    -- neo-tree
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      lazy = true,
      cmd = { "Neotree" },
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "folke/snacks.nvim",
      },
      config = function()
        require("config.neo-tree")
      end,
    },
    -- welcome dashboard（已换成 snacks.dashboard，见 lua/config/dashboard.lua）
    -- code outline
    {
      "hedyhli/outline.nvim",
      lazy = true,
      cmd = { "Outline", "OutlineOpen" },
      opts = {
        -- Your setup opts here
      },
    },
    ------------------------ language parser -----------------------
    -- treesitter (main 分支，新版 API)
    {
      "nvim-treesitter/nvim-treesitter",
      name = "nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("config.nvim-treesitter")
      end,
    },
    ------------------------- finder -------------------------------
    -- 模糊查找改用 snacks.picker（folke/snacks.nvim 已安装）
    --------------------------- git -------------------------------
    -- lazygit
    {
      "kdheepak/lazygit.nvim",
    },
    {
      "esmuellert/codediff.nvim",
      dependencies = { "MunifTanjim/nui.nvim" },
      cmd = "CodeDiff",
    },
    {
      "tveskag/nvim-blame-line",
    },
    ------------------------- auto-complete ------------------------
    {
      "Saghen/blink.cmp",
      version = "*",
      event = { "InsertEnter", "CmdlineEnter" },
      dependencies = {
        "fang2hou/blink-copilot",
      },
      config = function()
        require("config.blink")
      end,
    },
    -- Copilot / Anthropic
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("config.copilot")
      end,
    },
    -- ClaudeCode（暂时禁用，恢复时删除 enabled = false 即可）
    {
      "coder/claudecode.nvim",
      dependencies = { "folke/snacks.nvim" },
      lazy = true,
      enabled = false,
      config = true,
      opts = {
        terminal_cmd = "claude",
      },
    },
    -- OpenCode（暂时禁用，恢复时删除 enabled = false 即可）
    {
      "NickvanDyke/opencode.nvim",
      lazy = true,
      enabled = false,
      dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
      },
      config = function()
        vim.g.opencode_opts = {}
        -- Required for `opts.events.reload`.
        vim.o.autoread = true
      end,
    },

    -- ----------------- language specific tools -------------------------
    -- Adds extra functionality over rust analyzer
    -- {
    --   "mrcjkb/rustaceanvim",
    --   version = "^5", -- Recommended
    --   lazy = false, -- This plugin is already lazy
    --   ft = { "rust" },
    -- },
    -- for rust crates.io
    -- {
    --   "saecki/crates.nvim",
    --   tag = "stable",
    --   config = function()
    --     require("crates").setup()
    --   end,
    -- },
    -- clangd extension（p00f 仓库已废弃，源码迁移至 sr.ht/~chinmay，GitHub 镜像为 dchinmay2）
    {
      "dchinmay2/clangd_extensions.nvim",
      lazy = true,
      dependencies = {
        "jay-babu/mason-nvim-dap.nvim",
      },
    },
    -- python extension
    {
      "mfussenegger/nvim-dap-python",
      lazy = true,
    },
    {
      "linux-cultist/venv-selector.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python",
      },
      branch = "main",
      config = function()
        require("venv-selector").setup({
          auto_refresh = true,
        })
      end,
    },
    -- uv
    {
      "benomahony/uv.nvim",
      opts = {
        picker_integration = true,
      },
      config = function()
        require("config.uv").setup()
      end,
    },
    -- cmake
    {
      -- "cdelledonne/vim-cmake",
      "Civitasv/cmake-tools.nvim",
      lazy = true,
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require("config.cmake").setup()
      end,
    },
    -- dap settings
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = {
        "williamboman/mason.nvim",
      },
      lazy = true,
      config = function()
        require("mason-nvim-dap").setup({
          automatic_installation = true,
          ensure_installed = { "python", "cpptools", "codelldb" },
        })
      end,
    },
    {
      "rcarriga/nvim-dap-ui",
      lazy = true,
      dependencies = {
        "mfussenegger/nvim-dap",
        "jay-babu/mason-nvim-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
      },
      config = function()
        require("config.debugging").setup()
      end,
    },
    ------------------------- helper -------------------------------
    -- folds
    {
      "kevinhwang91/nvim-ufo",
      dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("config.nvim_ufo").setup()
      end,
    },
    -- commnet
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    },
    -- toggle terminal（已换成 snacks.terminal）
    -- which-key
    {
      "folke/which-key.nvim",
    },
    -- Makes Directories If They Don't Exist at Save Time
    {
      "jghauser/mkdir.nvim",
    },
    -- autopairs
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({})
      end,
    },
  },
  -- lazy.nvim opt
  {
    checker = {
      -- automatically check for plugin updates
      enabled = true,
      notify = false, -- get a notification when new updates are found
      frequency = 24 * 3600, -- check for updates every hour
    },
  }
)
