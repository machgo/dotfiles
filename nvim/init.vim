" load plugins via Plug
call plug#begin('~/.vim/plugged')
Plug 'PProvost/vim-ps1'
Plug 'fatih/vim-go'
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
Plug 'w0rp/ale'
Plug 'leafgarland/typescript-vim'
call plug#end()

" Leader-Combos (Leader = \)
" Git Commands
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gl :Gpull<CR>

" clear searchresults
nnoremap <Leader><space> :nohlsearch<CR>

" close all but the current one
nnoremap <Leader>o :only<CR>

" linting stuff for ale
let g:ale_linters = {
\   'typescript': ['tsserver'],
\}

" enable theme
set background=dark
color molokai
let g:airline_theme='molokai'

" utf8 encoding
set encoding=utf-8
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

" indentation
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4

" spaces instead of tabs
set expandtab

set ttyfast
set nocompatible
filetype plugin on
set modelines=0
set relativenumber

syntax on
set number
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set laststatus=2
set title
set showmode
set showcmd
set hidden
set ruler
set backspace=indent,eol,start
set visualbell

set shortmess=a
set cmdheight=1

set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=85

set timeout " Do time out on mappings and others
set timeoutlen=500 " Wait {num} ms before timing out a mapping

