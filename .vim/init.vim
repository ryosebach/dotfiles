source ~/.vim/.vimrc.keymap

" indent
set autoindent
set tabstop=4
set shiftwidth=4
set cursorcolumn
highlight CursorColumn ctermbg=Black

set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set number 

" ftpluginを読み込むようにする
filetype plugin on

" マウスも使えるように
set mouse=a

" 構文色分け
syntax on

" カレント行強調
" set cursorline
" highlight CursorLine term=underline cterm=underline

" インなんとかサーチを有効に
set incsearch


let g:deoplete#enable_at_startup = 1
let g:typescript_indent_disable = 1

call plug#begin('~/.vim/plugged')
Plug 'Shougo/deoplete.nvim' , { 'do': ':UpdateRemotePlugins' }
Plug 'padawan-php/deoplete-padawan', { 'do': 'composer install' }
Plug 'leafgarland/typescript-vim'
call plug#end()
