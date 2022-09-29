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
set shiftwidth=4 "indenting is 4 spaces
set expandtab " convert tabs to spaces
set relativenumber " relative number on left side
set number " show numbers on left side
set ignorecase " ignore case on search
set title " show current file in title of consoel
set visualbell " flash screen insted of beeping

set textwidth=80  " 80 chars per line
set colorcolumn=85 " show line at 85

set completeopt=menu,menuone,noselect " enable autocomplete

let g:go_fmt_command = "goimports"

let g:coq_settings = { 'auto_start': 'shut-up' }

nnoremap <leader>v <cmd>CHADopen<cr>
nnoremap <leader>l <cmd>call setqflist([])<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
