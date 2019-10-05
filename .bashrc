# .bashrc
# --------------------------------------------- 
# - https://github.com/ryosebach/dotfiles

# loading some file
test -r ~/.fzf.bash && . ~/.fzf.bash
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

USER_ICON="(˙༥˙)"
PS1='$(if [ $? = 0 ]; then 
		echo \[\e[32m\]; 
	else 
		echo \[\e[31m\]; 
	fi)'
PS1+=${USER_ICON}
#PS1+='\[\e[0m\]@'
PS1+='\[\e[37m\]\h'
PS1+='\[\e[0m\]:'
PS1+='\[\e[34m\]\w'
PS1+='\[\e[31m\]$(__git_ps1)'
PS1+='\[\e[0m\] \n\$ '


# --------------------------------------------- 
# for golang
# --------------------------------------------- 

export GOPATH=~/.go
export PATH=$GOPATH/bin:$PATH
if has 'ghq'; then
	export GHQ_ROOT=`ghq root`
fi

# --------------------------------------------- 
# alias field
# --------------------------------------------- 

if has 'nvim'; then
	alias vi='nvim'
	alias vim='nvim'
fi
alias cp="cp -i"
alias mv="mv -i"
alias du='du -h'

if has 'docker'; then
	alias d='docker'
	alias dc='docker-compose'
	alias dmysql='docker run -it --rm mysql mysql'
	alias dhostmysql='docker run --rm --name mysqld -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d -p 3306:3306 mysql'
	connect-dhostmysql () {
		docker run --link  mysqld:mysql -it --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot'
	}
fi

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
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ls='ls -G'
alias l='ls -l'
alias ll='ls -l'
alias la='ls -la'

export HISTCONTROL=ignoreboth
export HISTIGNORE="fg*:bg*:history*:cd*:ls:la:tig:g:vi:vim"

# --------------------------------------------- 
# for Interactive Filter Tools 
# --------------------------------------------- 

if [ -n "$FILTER_TOOL" ] ; then
	create-project () {
		if [ ! -z $1 ]; then
			local service=$(\ls -1 "$GHQ_ROOT" | $FILTER_TOOL)
			if [ -n "$service" ]; then
				local projFolder="$GHQ_ROOT/$service/$GITHUB_USERNAME/$1"
				mkdir $projFolder
				cd $projFolder
				git init
				gibo dump macos windows > .gitignore
				sed -i '' '1s/^/######### generated from gibo ###########'\\$'\n''/' .gitignore
				curl -sL raw.github.com/ryosebach/github_template/master/get_template.sh | bash
				echo "created $projFolder"
			else
				echo "Please Select Service"
			fi
		else
			echo "Please Input Project Name"
		fi
	}
	alias mkproj='create-project'
	
	filter-lscd () {
		local dir="$(find . -maxdepth 1 -type d | sed -e 's;\./;;' | $FILTER_TOOL)"
		if [ -n "$dir" ] ; then
			cd $dir
		fi
	}
	alias scd='filter-lscd'

	cd2repository () {
		local dir="$(ghq list --full-path | $FILTER_TOOL)"
		if [ -n "$dir" ]; then
			cd "$dir"
		fi
	}
	alias g='cd2repository'
	
	filter-and-ssh() {
	    local host=$(grep 'Host ' ~/.ssh/config | awk '{print $2}' | $FILTER_TOOL)
	    if [ -n "$host" ]; then
	        echo "ssh -F ~/.ssh/config $host"
	        ssh -F ~/.ssh/config $host
	    fi
	}
	
	alias sshh='filter-and-ssh'

	ssh-add-with-filter() {
		local sshFile=$(\ls -1 ~/.ssh | grep -v "\." | grep id | $FILTER_TOOL)
		eval `ssh-agent`
		ssh-add ~/.ssh/$sshFile
		echo "ssh-add $sshFile"
	}
	alias sshadd='ssh-add-with-filter'

	gbra() {
		git branch | cut -c 3-100 | $FILTER_TOOL
	}

	gcobra() {
		local branch=$(git branch | $FILTER_TOOL | cut -c 3-100)
		git co $branch
	}

	gpl() {
		local branch=$(git branch | cut -c 3-100 | $FILTER_TOOL)
		local remote=$(git remote | $FILTER_TOOL)
		git pull $remote $branch
	}

	if has 'hub'; then
		mkpull-request() {
			local baseBranch=$(git branch | cut -c 3-100 | $FILTER_TOOL)
			hub pull-request -b $baseBranch
		}
	fi
fi

# --------------------------------------------- 
# for peco 
# --------------------------------------------- 

if has 'peco'; then
	
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
	
fi
