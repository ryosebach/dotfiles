# .bashrc
# --------------------------------------------- 
# - https://github.com/ryosebach/dotfiles

# loading some file
test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect
test -r ~/.dotfiles/etc/lib/git-prompt.sh && . ~/.dotfiles/etc/lib/git-prompt.sh
test -r ~/.dotfiles/etc/lib/git-completion.bash && . ~/.dotfiles/etc/lib/git-completion.bash
# loading .bashrc for using os
test -r ~/.dotfiles/etc/lib/"$PLATFORM"/.bashrc && . ~/.dotfiles/etc/lib/"$PLATFORM"/.bashrc

# --------------------------------------------- 
# Setting option fot GIT_PS1
# https://gist.github.com/ryosebach/3217600f52dcae87d78961a1aa44a5b0
# --------------------------------------------- 

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1

# --------------------------------------------- 
# Setting PS1
# https://gist.github.com/ryosebach/1deee3855b7c8cec6e58970e4a1f5476
# --------------------------------------------- 

#PS1='$(if [ $? = 0 ]; then echo \[\e[32m\]; else echo \[\e[31m\]; fi)\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\] \$ '
PS1='$(if [ $? = 0 ]; then echo \[\e[32m\]; else echo \[\e[31m\]; fi)\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[31m\]$(__git_ps1)\[\e[0m\] \$ '

# --------------------------------------------- 
# for golang
# --------------------------------------------- 

export GOPATH=~/.go
export PATH=$GOPATH/bin:$PATH

# --------------------------------------------- 
#alias field
# --------------------------------------------- 

alias vi='nvim'
alias cp="cp -i"
alias mv="mv -i"
alias du='du -h'

alias grep='grep -E --color=auto'


export LS_COLORS='no=01;37:fi=00:di=01;36:ln=01;32:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;32;01:ex=01;33:*core=01;31:'
if [ -f ~/.dircolors ]; then
	if type dircolors > /dev/null 2>&1; then
		eval $(dircolors ~/.dircolors)
	elif type gdircolors > /dev/null 2>&1; then
		eval $(gdircolors ~/.dircolors)
	fi
fi


alias ..='cd ..'
alias ls='ls -G'
alias l='ls -l'
alias ll='ls -l'
alias la='ls -la'
alias up='cd ..; ls -l'


# --------------------------------------------- 
# for fzf
# --------------------------------------------- 

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

# --------------------------------------------- 
# for peco 
# --------------------------------------------- 

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
