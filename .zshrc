# .zshrc
# ---------------------------------------------
# - https://github.com/ryosebach/dotfiles

# loading some file
test -r ~/.fzf.zsh && . ~/.fzf.zsh
test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install && os_detect
# loading .zshrc for using os
test -r ~/.dotfiles/etc/lib/"$PLATFORM"/.zshrc && . ~/.dotfiles/etc/lib/"$PLATFORM"/.zshrc
test -r $(brew --prefix asdf)/libexec/asdf.sh && . $(brew --prefix asdf)/libexec/asdf.sh
eval "$(direnv hook zsh)"

export PATH="$HOME/.asdf/shims:$PATH"

# ---------------------------------------------
# for golangs
# ---------------------------------------------
# Note: GOPATH is not needed with Go Modules (Go 1.11+)
# GOBIN is removed to avoid conflicts in multi-platform builds
# Go Modules default location: $HOME/go/bin
export PATH=$HOME/go/bin:$HOME/bin:$PATH
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

	alias gwl='git worktree list'
	alias gwa='git worktree add'
	alias gwd='git worktree remove'
	alias gwm='git worktree move'

	# ブランチをfzfで選択してworktreeを作成
	gwb() {
		local branch=$(git branch -r | grep -v HEAD | sed "s/.*origin\///" | sed "s/^[[:space:]]*//" | fzf --height=40% --layout=reverse --cycle --border --prompt="Select branch: ")
		if [[ -n "$branch" ]]; then
			local name=$(echo "$branch" | sed "s/\//-/g")
			git worktree add "../$name" "$branch"
		fi
	}

	alias gwdel='git worktree remove $(git worktree list | grep -v "$(git rev-parse --show-toplevel)" | fzf --height=40% --layout=reverse --border --prompt="Delete worktree: " | awk "{print \$1}")'

	gwinfo() {
		local worktree=$(git worktree list --porcelain | awk "
			/^worktree/ { path=\$2 }
			/^branch/ { branch=\$2 }
			/^HEAD/ {
				if (branch) print path \" [\" branch \"]\"
				else print path \" [\" substr(\$2,1,8) \"]\"
			}
		" | fzf --height=40% --layout=reverse --border --prompt="Worktree info: ")

		if [[ -n "$worktree" ]]; then
			local path=$(echo "$worktree" | awk "{print \$1}")
			echo "=== Worktree: $path ==="
			echo "Files changed:"
			(cd "$path" && git status --porcelain | head -10)
			echo "\nRecent commits:"
			(cd "$path" && git log --oneline -5)
		fi
	}

	if has 'hub'; then
		mkpull-request() {
			local baseBranch=$(git branch | cut -c 3-100 | $FILTER_TOOL)
			hub pull-request -b $baseBranch
		}
	fi
fi

# ---------------------------------------------
# for gwq
# ---------------------------------------------

if has 'gwq'; then
	# worktree間でファイル移動（dstはgwqで選択）
	wtmv() {
		local src="$1"
		local dst_rel="$2"   # 省略可。省略時は同じ相対パスで置く

		if [ -z "$src" ]; then
			echo "Usage: wtmv <src> [dst_rel]"
			echo "  dst_rel omitted -> keep same relative path in destination worktree"
			return 1
		fi
		if [ ! -e "$src" ]; then
			echo "Source not found: $src"
			return 1
		fi

		# src側 worktree root と、rootからの相対パスを作る
		local src_root src_abs src_rel
		src_root="$(git rev-parse --show-toplevel)" || return 1
		src_abs="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
		src_rel="${src_abs#"$src_root"/}"

		# dst worktree を gwq で選ぶ（返り値はパス）
		local dst_root
		dst_root="$(gwq get)" || return 1
		# "~" を返す設定があり得るので展開
		dst_root="$(eval echo "$dst_root")"

		# dst 側に置く相対パス（省略なら src と同じ）
		[ -z "$dst_rel" ] && dst_rel="$src_rel"

		# 実移動
		mkdir -p "$dst_root/$(dirname "$dst_rel")" || return 1
		mv "$src_abs" "$dst_root/$dst_rel" || return 1

		# ★重要：worktreeごとに index が別なので、それぞれのworktreeで実行する
		# git -C "$dst_root" add "$dst_rel" || return 1
		# git -C "$src_root" rm --cached "$src_rel" >/dev/null 2>&1 || true

		echo "Moved:"
		echo "  from: $src_root/$src_rel"
		echo "    to: $dst_root/$dst_rel"
		echo ""
		echo "Next:"
		echo "  (src) git -C \"$src_root\" status"
		echo "  (dst) git -C \"$dst_root\" status"
	}

	# worktree間でファイルコピー（dstはgwqで選択 / ステージしない）
	wtcp() {
		local src="$1"
		local dst_rel="$2"   # 省略可。省略時は同じ相対パスで置く

		if [ -z "$src" ]; then
			echo "Usage: wtcp <src> [dst_rel]"
			echo "  dst_rel omitted -> keep same relative path in destination worktree"
			return 1
		fi
		if [ ! -e "$src" ]; then
			echo "Source not found: $src"
			return 1
		fi

		# src側 worktree root と rootからの相対パス
		local src_root src_abs src_rel
		src_root="$(git rev-parse --show-toplevel)" || return 1
		src_abs="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
		src_rel="${src_abs#"$src_root"/}"

		# dst worktree を gwq で選ぶ
		local dst_root
		dst_root="$(gwq get)" || return 1
		dst_root="$(eval echo "$dst_root")"  # "~" 展開

		# dst 側に置く相対パス（省略なら src と同じ）
		[ -z "$dst_rel" ] && dst_rel="$src_rel"

		# 上書き防止
		if [ -e "$dst_root/$dst_rel" ]; then
			echo "Destination already exists: $dst_root/$dst_rel"
			return 1
		fi

		mkdir -p "$dst_root/$(dirname "$dst_rel")" || return 1
		cp -a "$src_abs" "$dst_root/$dst_rel" || return 1

		echo "Copied:"
		echo "  from: $src_root/$src_rel"
		echo "    to: $dst_root/$dst_rel"
		echo "Note: not staged"
	}
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
