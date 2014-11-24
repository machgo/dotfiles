" initialize pathogen pkgmgmt
execute pathogen#infect()
filetype off
filetype plugin indent on
syntax on

" enable neocomplete
let g:neocomplete#enable_at_startup = 1


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

nnoremap j gj
nnoremap k gk
set ttyfast
set nocompatible
set modelines=0
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

" font 
set guifont=DejaVu_Sans_Mono_for_Powerline:h10:cANSI

set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=85

set timeout " Do time out on mappings and others
set timeoutlen=50 " Wait {num} ms before timing out a mapping

" 256 Colors
set t_Co=256

" Airline Plugin
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme='hybrid'

" enable theme
:colorscheme hybrid
set background=dark

