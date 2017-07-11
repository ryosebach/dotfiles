####################################################
# コマンドプロンプトにマシンメイトカレントのフルパスを表示
# gitのブランチ表示
# 色付けをするなどなど
####################################################
source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
#GIT_PS1_SHOWDIRTYSTATE=true
#export PS1='\[\033[32m\]\u\[\033[00m\]:\[\033[34m\]\W\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

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


PS1='$(if [ $? = 0 ]; then echo \[\e[32m\]; else echo \[\e[31m\]; fi)\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[31m\]$(__git_ps1)\[\e[0m\] \$ '

##############


################
#grep
###############
export GREP_COLOR='1;37;41'
alias grep='grep -E --color=auto'

################
# color
################
if [ "$TERM" == xterm ]
  then
  export TERM=xterm-color
fi


##############
#alias field
############

alias vim-plane='vim -u NONE -N'


######
#dir
######

export LS_COLORS='no=01;37:fi=00:di=01;36:ln=01;32:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;32;01:ex=01;33:*core=01;31:'
alias ls='ls -G'

alias ll='ls -l'
alias la='ls -la'
alias up='cd ..; ls -l'

cdls ()
{
	\cd "$@" && ll
}
alias cdl='cdls'

###########
#GUI*CUI
###########

alias f='open .'

#cd to the path of the front Finder window
cdf () {
  target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
  if [ "$target" != "" ]
  then
    cd "$target"
	pwd
  else
    echo 'No Finder window found' >&2
  fi
}

#cd to the path of the grep matching
jj () {
	if [ $1 ]; then
		JUMPDIR=$(find . -type d -maxdepth 1 | grep $1 | tail -1)
		if [[ -d $JUMPDIR && -n $JUMPDIR ]]; then
			cd $JUMPDIR
		else
			echo "directory not found"
		fi
	fi
}

# peco-cd
peco-lscd () {
	local dir="$( find . -maxdepth 5 -type d | sed -e 's;\./;;' | peco )"
	if [ ! -z "$dir" ] ; then
		cd "$dir"
	fi
}
alias plcd='peco-lscd'

unity () {
	local project_path=""
	if [ $# -ge 1 ] ; then
		if [ -d "$1" ] ; then
			project_path="$(cd "$1" && pwd)"
		else
			project_path="$(cd "$(dirname "$1")" && pwd)"
		fi
	else
		project_path="`pwd`"
	fi
	echo "unity open project : ${project_path}"
	/Applications/Unity/Unity.app/Contents/MacOS/Unity -projectPath "${project_path}" &
}
