" load plugins via Plug
call plug#begin('~/.vim/plugged')
Plug 'PProvost/vim-ps1'
Plug 'fatih/vim-go'
Plug 'tpope/vim-fugitive'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
call plug#end()

" Leader-Combos (Leader = \)
" Git Commands
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>gl :Git pull<CR>

" clear searchresults
nnoremap <Leader><space> :nohlsearch<CR>

" enable theme
colorscheme tokyonight

" indentation
set smartindent " try to smart indent new lines
set tabstop=4 " tabs = 4 spaces
set expandtab " convert tabs to spaces
set relativenumber " relative number on left side
set number " show numbers on left side
set ignorecase " ignore case on search
set title " show current file in title of consoel
set visualbell " flash screen insted of beeping

set textwidth=80  " 80 chars per line
set colorcolumn=85 " show line at 85

let g:go_fmt_command = "goimports"

let g:coq_settings = { 'auto_start': 'shut-up' }

nnoremap <leader>v <cmd>CHADopen<cr>
nnoremap <leader>l <cmd>call setqflist([])<cr>

lua << END
require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}
END
