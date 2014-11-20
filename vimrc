execute pathogen#infect()
filetype off
filetype plugin indent on
syntax on

" disable cursorkeys :)
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap j gj
nnoremap k gk
set ttyfast
set nocompatible
set modelines=0
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set number
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
set laststatus=2
set title
set encoding=utf-8
set autoindent
set showmode
set showcmd
set hidden
set ruler
set backspace=indent,eol,start
set visualbell

" Savefolders for undo,backup,swap
set undofile
set undodir=~/.vim/.undo//
set directory=~/.vim/.swp//
set backupdir=~/.vim/.backup//

set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=85

set timeout " Do time out on mappings and others
set timeoutlen=50 " Wait {num} ms before timing out a mapping

" Airline Plugin
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme='powerlineish'

