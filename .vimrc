" Minimilistic Vimrc for servers

" Remap escape
inoremap jk <Esc>

" Some needed settings
set number
set encoding=utf8
set colorcolumn=80 tabstop=4 shiftwidth=4 softtabstop=4
set showcmd
set expandtab
set autoread
set cursorline
set wildmenu

" Disable the default Vim startup message.
set shortmess+=I

" Set Darkmode
set bg=dark

if &t_Co > 2 || has("gui_running")
    " Switch on highlighting the last used search pattern.
    set hlsearch
endif

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable Mouse Support
set mouse+=a

" Always show the status line at the bottom, 
" even if you only have one window open.
set laststatus=2

" Sets the clipboard to system clipboard
set clipboard=unnamedplus

" Turn on syntax highlighting.
syntax on

" Open up vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" For python stuff
 au BufNewFile,BufRead *.py
     \ set fileformat=unix

" For stupid web dev
au BufNewFile,BufRead *.js,*.html,*.css,*.jsx
    \ setlocal tabstop=2
    \| setlocal softtabstop=2
    \| setlocal shiftwidth=2

" ColorScheme
colorscheme slate
