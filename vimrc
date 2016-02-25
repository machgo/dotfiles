set nocompatible

" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'PProvost/vim-ps1'
Plug 'w0ng/vim-hybrid'
Plug 'vim-scripts/Lucius'
Plug 'Shougo/neocomplete'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'lervag/vim-latex'
call plug#end()

" enable neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1

" increase cache_limit
let g:neocomplete#sources#tags#cache_limit_size = 10000000000


" disable folding in latex
let g:latex_fold_enabled = 0

" Plugin key-mappings noesnippets
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"
" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" disable cursorkeys :)
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Leader-Combos
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gl :Gpull<CR>

" enable theme
set background=dark
colorscheme lucius
LuciusBlack


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
let g:airline_theme='molokai'


