"indent"
set autoindent
set tabstop=4
set shiftwidth=4
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

" インサートモードでC-jkでコード追加
" inoremap <silent> <C-j> <Esc>$<Insert><RIGHT><Enter>
" inoremap <silent> <C-k> <Esc><UP>$<Insert><RIGHT><Enter>
inoremap <silent> <C-o> <Esc>$<Insert><RIGHT><Enter>
              	

" インサートモードでC-t/C-eで行の先頭/末尾へ移動
inoremap <silent> <C-t> <Esc>^<Insert><RIGHT>
inoremap <silent> <C-e> <Esc>$<Insert><RIGHT>
"

" jj/kkでインサートモードから抜ける
inoremap <silent> jj <ESC>j
inoremap <silent> kk <ESC>k

" インサートモードでC-d C-dで行削除
inoremap <silent> <C-d><C-d> <ESC>dd<Insert>
