# .zshrc
# ---------------------------------------------
# - https://github.com/ryosebach/dotfiles

# loading some file
test -r ~/.fzf.zsh && . ~/.fzf.zsh
test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect
# loading .zshrc for using os
test -r ~/.dotfiles/etc/lib/"$PLATFORM"/.zshrc && . ~/.dotfiles/etc/lib/"$PLATFORM"/.zshrc
test -r $(brew --prefix asdf)/libexec/asdf.sh && . $(brew --prefix asdf)/libexec/asdf.sh

export PATH="$HOME/.asdf/shims:$PATH"

# ---------------------------------------------
# for golangs
# ---------------------------------------------

export GOPATH=~/.go
export PATH=$GOPATH/bin:$HOME/bin:$PATH
if has 'ghq'; then
	export GHQ_ROOT=`ghq root`
fi


# Configure for Bedrock with Claude 3.7 Sonnet
export CLAUDE_CODE_USE_BEDROCK=1
#export ANTHROPIC_MODEL='us.anthropic.claude-3-7-sonnet-20250219-v1:0'
export ANTHROPIC_MODEL='anthropic.claude-3-5-sonnet-20240620-v1:0'

# Control prompt caching - set to 1 to disable (see note below)
export DISABLE_PROMPT_CACHING=1

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
	alias dhostmysql='docker run --rm --name mysqld -v ~/.dotfiles/etc/lib/mysql:/etc/mysql/conf.d -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d -p 3306:3306 mysql:5.6'
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

setopt hist_ignore_all_dups
setopt hist_ignore_space
zstyle ':completion:*:(ssh|scp|rdp):*' hosts off
zstyle ':completion:*:(ssh|scp|rdp):*' users off

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

	gsw() {
		local branch=$(git branch | $FILTER_TOOL | cut -c 3-100)
		git co $branch
	}

	gpl() {
		local branch=$(git branch | cut -c 3-100 | $FILTER_TOOL)
		local remotes=$(git remote)
		local remote=$(pickApplicable "upstream:origin" "$remotes")
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

# Added by Windsurf
export PATH="/Users/ryosei/.codeium/windsurf/bin:$PATH"
