-- Initialize the Neovim configuration
-- Set leader key
vim.g.mapleader = " "

-- Enable line numbers
vim.wo.number = true

-- Load plugins using packer.nvim
require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- File traversal
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons'
  }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Git support
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- LSP and autocomplete
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'L3MON4D3/LuaSnip'

  -- Language-specific LSP servers
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
end)

-- Configure plugins
require('nvim-tree').setup {}
require('gitsigns').setup {}

-- LSP setup
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Language servers
local servers = { 'clangd', 'jdtls', 'sourcekit', 'pyright' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities
  }
end

-- Autocomplete setup
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  })
}

-- Key mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Fuzzy finder (Telescope)
map('n', '<leader>ff', "<cmd>Telescope find_files<cr>", opts)
map('n', '<leader>fg', "<cmd>Telescope live_grep<cr>", opts)
map('n', '<leader>fb', "<cmd>Telescope buffers<cr>", opts)
map('n', '<leader>fh', "<cmd>Telescope help_tags<cr>", opts)

-- Key mapping for file explorer (nvim-tree)
map('n', '<leader>e', "<cmd>NvimTreeToggle<cr>", opts)

-- Key mapping to show diagnostics for the current line
map('n', '<leader>d', "<cmd>lua vim.diagnostic.open_float()<cr>", opts)