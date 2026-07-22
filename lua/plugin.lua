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
      opts = {
        input = { enabled = true },
        notifier = { enabled = true },
        picker = { enabled = true },
        image = { enabled = false },
        explorer = { enabled = false },
      },
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
    {
      "glepnir/lspsaga.nvim",
      branch = "main",
      dependencies = { "catppuccin/nvim", "lewis6991/gitsigns.nvim" },
      config = function()
        require("config.lspsaga").setup()
      end,
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
    -- Ctags auto generation
    {
      "ludovicchabant/vim-gutentags",
      branch = "master",
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
    -- session manager
    {
      "rmagatti/auto-session",
      lazy = false,

      opts = {
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        close_filetypes_on_save = { "checkhealth", "opencode_terminal" },
      },
    },

    ----------------------------- ui -----------------------------
    -- themes
    { "projekt0n/github-nvim-theme", lazy = false, priority = 1000, name = "github" },
    { "EdenEast/nightfox.nvim", lazy = false, priority = 1000, name = "nightfox" },
    { "navarasu/onedark.nvim", lazy = false, priority = 1000, name = "onedark" },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, name = "tokyonight" },
    -- auto dark mode (via terminal OSC 11)
    {
      "afonsofrancof/OSC11.nvim",
      opts = {
        on_dark = function()
          vim.opt.background = "dark"
          vim.cmd("colorscheme tokyonight")
        end,
        on_light = function()
          vim.opt.background = "light"
          vim.cmd("colorscheme github_light")
        end,
      },
      config = function(_, opts)
        require("osc11").setup(opts)
        -- fallback: OSC11 only listens for TermResponse, never queries itself.
        -- If the terminal doesn't respond (no OSC 11 support, race on startup),
        -- neither callback fires and no colorscheme is set.
        vim.api.nvim_create_autocmd("VimEnter", {
          once = true,
          callback = function()
            if vim.g.colors_name then return end
            vim.opt.background = "dark"
            vim.cmd("colorscheme tokyonight")
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
    -- welcome dashboard
    {
      "goolord/alpha-nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("config.alpha")
      end,
    },
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
    -- telescope
    {
      "nvim-telescope/telescope.nvim",
      name = "telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      -- 移除 0.1.x 分支限制，master 分支已修复与 nvim-treesitter main 分支的兼容性 (PR #3566)
      config = function()
        require("config.telescope")
      end,
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = have_make and "make"
        or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      enabled = have_make or have_cmake,
      dependencies = { "telescope.nvim" },
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      dependencies = { "telescope.nvim" },
    },
    {
      "nvim-telescope/telescope-frecency.nvim",
      dependencies = { "telescope.nvim" },
    },
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
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline", -- { name = 'cmdline' }
        -- lspkind
        "onsails/lspkind-nvim",
        -- crates
        -- {
        --   "Saecki/crates.nvim",
        --   event = { "BufRead Cargo.toml" },
        --   opts = {
        --     completion = {
        --       cmp = { enabled = true },
        --     },
        --   },
        -- },
      },
      config = function()
        require("config.nvim-cmp")
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
    {
      "zbirenbaum/copilot-cmp",
      dependencies = { "copilot.lua" },
      config = function()
        require("copilot_cmp").setup()
      end,
    },
    -- ClaudeCode
    {
      "coder/claudecode.nvim",
      dependencies = { "folke/snacks.nvim" },
      lazy = true,
      config = true,
      opts = {
        terminal_cmd = "claude",
      },
    },
    -- OpenCode
    {
      "NickvanDyke/opencode.nvim",
      lazy = true,
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
    -- clangd extension
    {
      "p00f/clangd_extensions.nvim",
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
        "nvim-telescope/telescope.nvim",
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
        "nvim-telescope/telescope-dap.nvim",
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
    -- toggle terminal
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("config.toggle_term")
      end,
    },
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
