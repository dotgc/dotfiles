set nocompatible
filetype on " intentional
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'austintaylor/vim-indentobject'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'juvenn/mustache.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'majutsushi/tagbar'
Plugin 'rking/ag.vim'
Plugin 'garbas/vim-snipmate'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'nono/vim-handlebars'
Plugin 'pangloss/vim-javascript'
Plugin 'wookiehangover/jshint.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'scrooloose/syntastic'
Plugin 'slim-template/vim-slim'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-cucumber'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-pastie'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vividchalk'
Plugin 'eventualbuddha/vim-protobuf'
Plugin 'fatih/vim-go'
Plugin 'davidhalter/jedi-vim'
Plugin 'nvie/vim-flake8'
Plugin 'vim-scripts/Align'
Plugin 'vim-scripts/greplace.vim'
Plugin 'vim-scripts/matchit.zip'
Plugin 'vim-airline/vim-airline'
Plugin 'hdima/python-syntax'
" All of your Plugins must be added before the following line
call vundle#end()            " required

set background=dark
colorscheme solarized

filetype plugin indent on
syntax on " enable syntax highlighting
set tabstop=2 " set tabs to have 2 spaces
set shiftwidth=2 " when using the >> or << commands, shift lines by 2 spaces
set expandtab " expand tabs into spaces
set cursorline " show a visual line under the cursor's current line
set showmatch "show the matching part of the pair for [] {} and ()
set number " show line numbers
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set encoding=utf-8
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
set term=xterm-256color

set tw=150
set formatoptions+=t
set autoindent " indent when moving to the next line while writing code
set undofile " persistent undo
:set mouse=a

hi Comment ctermfg=blue


" keyboard shortcuts
let mapleader = ','
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>l :Align
nnoremap <leader>a :Ag<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>g :GitGutterToggle<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %


" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0


" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" When opening a new file, use a skeleton to get started
autocmd! BufNewFile * silent! 0r ~/.vim/skeleton.%:e

" Delete trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP


" leader key
let mapleader=","

" convenience
imap jj <ESC>
nnoremap ; :

" Get a git diff in the other window
map <F9> :only<CR>:below vnew<CR>:read !git --no-pager diff<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg

:set hlsearch
" only the current file
map <F10> :only<CR>:let @" = expand("%")<CR>:below vnew<CR>:read !git --no-pager diff "<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg

" make a scratch buffer
map <leader>x :only<CR>:below vnew<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg

" Toggle highlight when <leader><leader> is pressed
map <silent> <leader><leader> :set hlsearch! hlsearch?<CR>

let g:jedi#auto_close_doc = 1
let g:jedi#popup_on_dot = 0

let python_highlight_all = 1
