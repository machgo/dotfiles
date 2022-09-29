" load plugins via Plug
call plug#begin('~/.vim/plugged')
Plug 'PProvost/vim-ps1'
Plug 'fatih/vim-go'
Plug 'tpope/vim-fugitive'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lualine/lualine.nvim'
" tree plugin
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
" treesitter stuff
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" telescope for fuzzy search
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
" nvim-cmp for completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
" lsp stuff
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
call plug#end()