-- Bootstrap packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.execute('git clone https://github.com/wbthomason/packer.nvim' .. install_path)
end

-- Make packer sync plugins everytime this file is saved
local group = vim.api.nvim_create_augroup( "Packer" , { clear = true } )
vim.api.nvim_create_autocmd( "BufWritePost" , {
  command = "source <afile> | PackerSync",
  pattern ="plugins.lua",
  group = group
})

return require('packer').startup({function(use)
  use 'wbthomason/packer.nvim' -- Make Packer manage itself
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- LSP ( Language Server Protocol )
  use {'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer' }
  use 'onsails/lspkind-nvim'
  use 'nvim-lua/lsp_extensions.nvim'

  --[[ -- DAP ( Debug Adapter Protocol )
  use 'mfussenegger/nvim-dap'
  use 'leoluz/nvim-dap-go'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'nvim-telescope/telescope-dap.nvim' ]]

  -- Completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use {'saadparwaiz1/cmp_luasnip', requires = 'L3MON4D3/LuaSnip' }
  use 'mattn/emmet-vim'

  -- Navigation
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {'nvim-telescope/telescope-ui-select.nvim' }
  use 'nanotee/zoxide.vim'
  use { 'goolord/alpha-nvim',
    config = function ()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  }
  use { 'numToStr/Comment.nvim',
    config = function()
      require 'Comment'.setup()
    end
  }

  -- Visual
  use 'kyazdani42/nvim-web-devicons'
  use 'ellisonleao/gruvbox.nvim'
  use 'folke/tokyonight.nvim'
  use 'rockerBOO/boo-colorscheme-nvim'
  --[[ use { "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function ()
      require 'todo-comments'.setup()
    end
  } ]]
  use { 'norcalli/nvim-colorizer.lua',
    config= function()
      require 'colorizer'.setup()
    end
  }

  -- Speeds up neovim by caching
  use {'lewis6991/impatient.nvim',
    config = function()
      require 'impatient'
    end }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end,
  config = {
    display = {
      open_fn = require('packer.util').float,
}}})
