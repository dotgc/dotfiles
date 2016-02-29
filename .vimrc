execute pathogen#infect()
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set tw=150
set formatoptions+=t
"set smartindent
set nosmartindent  " plugin indent on seems to do a better job
filetype plugin indent on

hi Comment ctermfg=blue

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif

" When opening a new file, use a skeleton to get started
autocmd! BufNewFile * silent! 0r ~/.vim/skeleton.%:e

" Delete trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" leader key
let mapleader=","

" convenience
imap jj <ESC>
nnoremap ; :

set incsearch

" persistent undo
set undofile

" Get a git diff in the other window
map <F9> :only<CR>:below vnew<CR>:read !git --no-pager diff<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg

:set hlsearch
" only the current file
map <F10> :only<CR>:let @" = expand("%")<CR>:below vnew<CR>:read !git --no-pager diff "<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg

" make a scratch buffer
map <leader>x :only<CR>:below vnew<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg

" pyflakes on this file
map <silent><leader>p :cex system('pyflakes ' . expand('%'))<CR>:cw<CR>

" only breaking pychanges on this file
map <silent><leader>P :cex system('pybreaking.py ' . expand('%'))<CR>:cw<CR>

" Toggle highlight when <leader><leader> is pressed
map <silent> <leader><leader> :set hlsearch! hlsearch?<CR>

:set mouse=a
