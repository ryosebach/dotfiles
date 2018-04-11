export GOPATH=~/.go

# 各種スクリプトの読み込みを行う
test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect
test -r ~/.dotfiles/etc/lib/git-prompt.sh && . ~/.dotfiles/etc/lib/git-prompt.sh
test -r ~/.dotfiles/etc/lib/git-completion.bash && . ~/.dotfiles/etc/lib/git-completion.bash
# OS依存のbashrcを読み込む
test -r ~/.dotfiles/etc/lib/"$PLATFORM"/.bashrc && . ~/.dotfiles/etc/lib/"$PLATFORM"/.bashrc

#################  プロンプトに各種情報を表示
# GIT_PS1_SHOWUPSTREAM
# 現在のブランチがupstreamより進んでいるとき">"を
# 遅れているとき"<"を、遅れてるけど独自の変更もあるとき"<>"を
# 同じ時"="を表示する。
# 
# GIT_PS1_SHOWUNTRACKEDFILES
# addされてない新規ファイルがある(untracked)とき"%"を表示する
#
# GIT_PS1_SHOWSTASHSTATE
# stashになにか入っている(stashed)とき"$"を表示する
#
# GIT_PS1_SHOWDIRTYSTATE
# addされてない変更(unstaged)があったとき"*"を表示する
# addされているがcommitされていない変更(staged)があったとき"+"を表示する
###################


GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=
GIT_PS1_SHOWSTASHSTATE=1

############### ターミナルのコマンド受付状態の表示変更
# \u ユーザ名
# \h ホスト名
# \W カレントディレクトリ
# \w カレントディレクトリのパス
# \n 改行
# \d 日付
# \[ 表示させない文字列の開始
# \] 表示させない文字列の終了
# \$ $
#####################

#export PS1='\[\033[1;32m\]\u\[\033[00m\]:\[\033[1;34m\]\W\[\033[1;31m\]$(__git_ps1)\[\033[00m\] \$ '
#export PS1='\[\e[32m\]\u\[\e[0m\]:\[\e[34m\]\W\[\e[31m\]$(__git_ps1)\[\e[0m\] \$ '


#PS1='$(if [ $? = 0 ]; then echo \[\e[32m\]; else echo \[\e[31m\]; fi)\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\] \$ '
PS1='$(if [ $? = 0 ]; then echo \[\e[32m\]; else echo \[\e[31m\]; fi)\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[31m\]$(__git_ps1)\[\e[0m\] \$ '






#alias field

alias nvim='vim -u NONE -N -i NONE'
alias vi='vim'
alias cp="cp -i"
alias mv="mv -i"
alias du='du -h'

alias grep='grep -E --color=auto'


export LS_COLORS='no=01;37:fi=00:di=01;36:ln=01;32:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;32;01:ex=01;33:*core=01;31:'


alias ..='cd ..'
alias ls='ls -G'
alias l='ls -l'
alias ll='ls -l'
alias la='ls -la'
alias up='cd ..; ls -l'



if has 'fzf'; then

	init-proj () {
		if [ ! -z $1 ]; then
			local service=$(\ls -1 "$GOPATH/src" | fzf)
			local projFolder="$GOPATH/src/$service/ryosebach/$1"
			mkdir $projFolder
			cd $projFolder
			pwd
			git init
			curl -sL raw.github.com/ryosebach/github_template/master/get_template.sh | bash
			echo "created $projFolder"
		else
			echo "Please input ProjectName"
		fi
	}

fi

##########
## peco ##
##########

if has 'peco'; then
	# peco-cd
	peco-lscd () {
		local dir="$( find . -maxdepth 1 -type d | sed -e 's;\./;;' | peco )"
		if [ ! -z "$dir" ] ; then
			cd "$dir"
		fi
	}
	alias plcd='peco-lscd'
	
	
	# repositoryにcdする．escで抜けた時は移動しないように
	function pcd {
		local dir="$(ghq list | peco)"
		if [ ! -z "$dir" ] ; then
			cd "$(ghq root)/$dir"
		fi
	}
	alias g='pcd'
	
	peco-select-history() {
		declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")
		READLINE_LINE="$l"
		READLINE_POINT=${#l}
	}
	bind -x '"\C-r": peco-select-history'
	
	
	# search current directory
	peco-find() {
		local l=$(\find . -maxdepth 8 -a \! -regex '.*/\..*' | peco)
		READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${l}${READLINE_LINE:$READLINE_POINT}"
		READLINE_POINT=$(($READLINE_POINT + ${#l}))
	}
	function peco-find-all() {
		local l=$(\find . -maxdepth 8 | peco)
		READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${l}${READLINE_LINE:$READLINE_POINT}"
		READLINE_POINT=$(($READLINE_POINT + ${#l}))
	}
	bind -x '"\C-uc": peco-find'
	bind -x '"\C-ua": peco-find-all'
	
	peco-sshconfig-ssh() {
	    local host=$(grep 'Host ' ~/.ssh/config | awk '{print $2}' | peco)
	    if [ -n "$host" ]; then
	        echo "ssh -F ~/.ssh/config $host"
	        ssh -F ~/.ssh/config $host
	    fi
	}
	
	alias sshpeco='peco-sshconfig-ssh'

	make-project() {
		local service=$(ls -1 $GOPATH | peco)
		local projFolder="$GOPATH/$service/ryosebach/$1"
		mkdir $projFolder
		cd $projFolder
		git init
	}
	alias mkproj='make-project'
fi


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
