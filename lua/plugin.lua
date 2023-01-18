-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup({ function(use)
  -- Your plugins here
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim' }
  use {
    'williamboman/mason.nvim',
    config = function()
      require("config.mason")
    end,
  }
  ----------------------------- lsp -----------------------------
  use { 'williamboman/mason-lspconfig.nvim' }
  use { 'ray-x/lsp_signature.nvim' }
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'ray-x/lsp_signature.nvim',
    },
    config = function()
      require('config.lsp')
    end,
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require('config.null-ls')
    end,
  }
  use { 'arkav/lualine-lsp-progress' }
  use { 'lukas-reineke/lsp-format.nvim' }
  use {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require('config.lspsaga')
    end,
  }

  ----------------------------- ui -----------------------------
  -- themes
  use 'Mofiqul/dracula.nvim'
  use "EdenEast/nightfox.nvim"
  use 'marko-cerovac/material.nvim'
  use 'navarasu/onedark.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }
  -- line in the bottom
  use {
    'nvim-lualine/lualine.nvim',
    requires = { "kyazdani42/nvim-web-devicons", opt = false },
    config = function()
      require("config.lualine")
    end,
    after = "nvim-web-devicons",
  }
  -- indent-blankline
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('config.indent-blankline')
    end,
  }
  -- bufferline
  use {
    'akinsho/bufferline.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = false },
    config = function()
      require('config.bufferline')
    end,
    after = "nvim-web-devicons",
  }
  use {
    'kazhala/close-buffers.nvim',
  }
  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = false },
    config = function()
      require('config.nvim-tree')
    end,
    after = "nvim-web-devicons",
  }
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('config.alpha')
    end
  }

  ------------------------ language parser -----------------------
  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      "nvim-treesitter/nvim-treesitter-refactor",
      'p00f/nvim-ts-rainbow',
    },
    config = function()
      require('config.nvim-treesitter')
    end,
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  }
  ------------------------ code helper -----------------------
  -- commnet
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  -- toggle terminal
  use {
    "akinsho/toggleterm.nvim",
    tag = 'v2.*',
    config = function()
      require("config.toggle_term")
    end
  }
  ------------------------- finder -------------------------------
  -- telescope
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
    config = function()
      require('config.telescope')
    end
  }
  --------------------------- git -------------------------------
  -- gitsigns
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require("config.gitsigns")
    end
  }
  -- lazygit
  use {
    'kdheepak/lazygit.nvim',
  }
  -- diffview
  -- TODO need more document for this
  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }
  ------------------------- auto-complete ------------------------
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline", -- { name = 'cmdline' }
      -- vsnip
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
      -- lspkind
      "onsails/lspkind-nvim",
      -- nerd-font
      "davidmh/cmp-nerdfonts",
    },
    config = function()
      require('config.nvim-cmp')
    end,
  }

  ------------------- language specific --------------------------
  -- Adds extra functionality over rust analyzer
  -- use {
  -- "simrat39/rust-tools.nvim",
  -- config = function()
  -- require('config.rust-tools')
  -- end
  -- }
  -- clangd extension
  -- use {
  -- "p00f/clangd_extensions.nvim"
  -- }
  ------------------------- helper -------------------------------
  -- which-key
  use {
    'folke/which-key.nvim',
    config = function()
      require('config.which-key')
    end
  }
  -- Makes Directories If They Don't Exist at Save Time
  use {
    "jghauser/mkdir.nvim",
  }
  -- autopairs
  use {
    "windwp/nvim-autopairs",
    config = function()
      require('nvim-autopairs').setup {}
    end
  }
  ------------------------- debugger ----------------------------
  use {
    'mfussenegger/nvim-dap',
    opt = true,
    event = "BufReadPre",
    module = { "dap" },
    requires = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope-dap.nvim",
    },
  }
  ------------------------- utils -------------------------------
  -- for speeding up the loading of plugin
  use {
    'lewis6991/impatient.nvim'
  }
end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    }
  } })
