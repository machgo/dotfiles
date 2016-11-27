set nocompatible

" load plugins via Plug
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'PProvost/vim-ps1'
Plug 'w0ng/vim-hybrid'
Plug 'Shougo/neocomplete'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'morhetz/gruvbox'
Plug 'elentok/plaintasks.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'
Plug 'fatih/vim-go'
call plug#end()

" enable neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1

" increase cache_limit
let g:neocomplete#sources#tags#cache_limit_size = 10000000000

" <TAB>: for jump to next entry
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Plugin key-mappings noesnippets
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Leader-Combos (Leader = \)
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gl :Gpull<CR>

nnoremap <Leader><space> :nohlsearch<CR>

" enable theme
set background=dark
colorscheme gruvbox


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

" long lines as break lines
nnoremap j gj
nnoremap k gk
set ttyfast
set nocompatible
set modelines=0

" spaces instead of tabs
set expandtab

syntax on
set number
set ignorecase
set smartcase
set gdefault
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

" Savefolders for undo,backup,swap
set undofile
set undodir=~/.vim/.undo//
set directory=~/.vim/.swp//
set backupdir=~/.vim/.backup//

" font 
set guifont=DejaVu_Sans_Mono_for_Powerline:h10:cANSI

set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=85

set timeout " Do time out on mappings and others
set timeoutlen=500 " Wait {num} ms before timing out a mapping

" 256 Colors
set t_Co=256

" Airline Plugin
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1

" remove toolbars in gvim
set guioptions-=m
set guioptions-=T

" maximize on startup (on Windows)
au GUIEnter * simalt ~x
