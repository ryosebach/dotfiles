" C言語用のインデントの設定
" :setcindent

 " タブの設定
 :set ts=4
 :set sw=4

 " 行番号を表示
 :set number

 " ステータスラインを表示するようにする
 set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L]
 :set laststatus=2

 " C言語用の設定
 :inoremap {<Enter> {}<Left><CR><ESC><S-o>

 :inoremap #inc #include<Space><><LEFT>
 :inoremap #def #define<Space>
 :inoremap Head #include <stdio.h><Enter>#include <stdlib.h><Enter>

 :inoremap Main int main(int argc, char *argv[])<Enter>{<Enter><Enter>return 0;<Enter>}<Up><Up>
 :inoremap f(" f("")<LEFT><LEFT>
 :inoremap Pe fprintf(stderr,"/n");<LEFT><LEFT><LEFT><LEFT><LEFT>
 :inoremap Fori for (i = 0; i < NUM; i++) {<Enter><Enter>}<Up>
 :inoremap Switch switch(c) {<Enter>default:<Enter>break;<Enter>}<Up><Up><Up>

 :inoremap Malloc if ((DATA = (TYPE *) malloc(sizeof(TYPE) * NUM)) == NULL) {<Enter>fprintf(stderr, "Can't allocate memory!\n");<Enter>exit(1);<Enter>}<Enter>/*need free*/<Up><Up><Up><Up>

 :inoremap Fopen if ((fp = fopen(argv[1], "r")) == NULL) {<Enter>fprintf(stderr, "Can't open file %s\n", argv[1]);<Enter>exit(1);<Enter>}
 :inoremap Fgetc while ((c = fgetc(fp)) != EOF) {<Enter>c;<Enter>}<Up>
 :inoremap Getchar while ((c = getchar(fp)) != EOF) {<Enter>c;<Enter>}<Up>

 :inoremap Va va_list va_ptr;<Enter>va_start(va_ptr, num);<Enter>for (i = 0; i < num; i++) {<Enter>/*something about*/<Enter>va_arg(va_ptr, int);<Enter>}<Enter>va_end(va_ptr);
 :inoremap Argc if (argc != 2) {<Enter>fprintf(stderr, "Usage: %s \n", argv[0]);<Enter>exit(1);<Enter>}

 :function! RRFunction()
     :w
         :let compile = system('gcc -o temp.out '.expand('%:p'))
             :call append(line('$'), split("/*", "", 1))
    :if !v:shell_error
        :call cursor(line('$'), 0)
        :let arg = input('% ./temp.out ')
        :execute 'r!./temp.out'.' '.arg
        :call system('rm -f temp.out')
    :else
        :call append(line('$'), split(compile, "\n", 1))
    :endif
    :call append(line('$'), split("*/", "", 1))
:endfunction
:command RR :call RRFunction()


:function! CFunction()
    :w
    :let outfile = input("output filename and othersourcefile: ")
    :let compile = system('gcc -o '.outfile.' '.expand('%:p'))
    :if !v:shell_error
        :echo 'successfully compiled'
    :else
        :echo compile
    :endif
:endfunction
:command C :call CFunction()

:function! DFunction()
    :w
    :let outfile = input("output filename and othersourcefile: ")
    :let compile = system('gcc -DDEBUG -o '.outfile.' '.expand('%:p'))
    :if !v:shell_error
        :echo 'successfully compiled'
    :else
        :echo compile
    :endif
:endfunction
:command D :call DFunction()
<Paste>
