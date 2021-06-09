" load plugins via Plug
call plug#begin('~/.vim/plugged')
Plug 'PProvost/vim-ps1'
Plug 'fatih/vim-go'
Plug 'tpope/vim-fugitive'
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
set background=dark

" indentation
set smartindent
set tabstop=4
set expandtab
set relativenumber
set number
set ignorecase
set title
set visualbell

set textwidth=80
set colorcolumn=85

let g:go_fmt_command = "goimports"

