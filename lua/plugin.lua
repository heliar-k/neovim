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
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup(
  {
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
      "nvimtools/none-ls.nvim",
    },
    {
      "glepnir/lspsaga.nvim",
      branch = "main",
      dependencies = { "catppuccin/nvim", "lewis6991/gitsigns.nvim" },
      config = function()
        require("config.lspsaga").setup()
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

    ----------------------------- ui -----------------------------
    -- themes
    -- { "catppuccin/nvim",             name = "catppuccin" },
    { "projekt0n/github-nvim-theme", name = "github" },
    -- { "navarasu/onedark.nvim",       name = "onedark" },
    { "EdenEast/nightfox.nvim", name = "nightfox" },
    -- auto dark mode
    {
      "f-person/auto-dark-mode.nvim",
      dependencies = {
        "github",
        "nightfox",
      },
      opts = {
        update_interval = 6000,
        set_dark_mode = function()
          vim.api.nvim_set_option("background", "dark")
          vim.cmd("colorscheme nightfox")
        end,
        set_light_mode = function()
          vim.api.nvim_set_option("background", "light")
          vim.cmd("colorscheme github_light_default")
        end,
      },
    },
    -- automatic themes switcher
    -- {
    --   'JManch/sunset.nvim',
    --   dependencies = {
    --     "github",
    --     "nightfox"
    --   },
    --   config = function()
    --     require('config.sunset').setup()
    --   end,
    --   lazy = false,
    --   priority = 1000,
    --   opts = {
    --     latitude = 30.16,
    --     longitude = 120.12,
    --   },
    -- },
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
    -- indent-blankline
    {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("config.indent-blankline")
      end,
    },
    -- barbar
    {
      "romgrk/barbar.nvim",
      dependencies = {
        "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
        "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
      },
      config = function ()
        require("config.barbar").setup()
      end
    },
    -- bufferline
    -- {
    --   "akinsho/bufferline.nvim",
    --   dependencies = { "nvim-tree/nvim-web-devicons" },
    --   config = function()
    --     require("config.buffer-line")
    --   end,
    -- },
    {
      "kazhala/close-buffers.nvim",
    },
    -- neo-tree
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
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
    -- treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      name = "nvim-treesitter",
      config = function()
        require("config.nvim-treesitter")
      end,
      build = ":TSUpdate",
    },
    {
      "nvim-treesitter/nvim-treesitter-refactor",
      dependencies = { "nvim-treesitter" },
    },
    ------------------------- finder -------------------------------
    -- telescope
    {
      "nvim-telescope/telescope.nvim",
      name = "telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      branch = "0.1.x",
      config = function()
        require("config.telescope")
      end,
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      dependencies = { "telescope.nvim" },
    },
    --------------------------- git -------------------------------
    -- gitsigns
    {
      "lewis6991/gitsigns.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.gitsigns")
      end,
    },
    -- lazygit
    {
      "kdheepak/lazygit.nvim",
    },
    -- diffview
    -- TODO need more document for this
    {
      "sindrets/diffview.nvim",
      lazy = true,
      dependencies = "nvim-lua/plenary.nvim",
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
        {
          "Saecki/crates.nvim",
          event = { "BufRead Cargo.toml" },
          opts = {
            completion = {
              cmp = { enabled = true },
            },
          },
        },
      },
      config = function()
        require("config.nvim-cmp")
      end,
    },
    -- Copilot
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
    ------------------------- debugger ----------------------------
    -- language specific tools
    -- Adds extra functionality over rust analyzer
    {
      "mrcjkb/rustaceanvim",
      version = "^5", -- Recommended
      lazy = false, -- This plugin is already lazy
      ft = { "rust" },
    },
    -- for rust crates.io
    {
      "saecki/crates.nvim",
      tag = "stable",
      config = function()
        require("crates").setup()
      end,
    },
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
    -- scala
    -- {
    --   'scalameta/nvim-metals',
    --   dependencies = "nvim-lua/plenary.nvim",
    -- },
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
    -- obsidian
    -- {
    --   "epwalsh/obsidian.nvim",
    --   lazy = true,
    --   ft = "markdown",
    --   dependencies = {
    --     "nvim-lua/plenary.nvim",
    --   },
    --   opts = {
    --     workspaces = {
    --       name = "one_for_all",
    --       path = "/Users/guankai/Library/CloudStorage/OneDrive-个人/obsidian_library",
    --     },
    --   },
    --   config = function()
    --     require("config.obsidian")
    --   end,
    -- },
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
