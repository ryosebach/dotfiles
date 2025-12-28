test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install


test -r $HOME/.nodebrew/current/bin && export PATH=$PATH:$HOME/.nodebrew/current/bin
test -r $HOME/.rbenv/bin && export PATH=$HOME/.rbenv/bin:$PATH
test -r $HOME/.tfenv/bin && export PATH=$HOME/.tfenv/bin:$PATH
if has 'rbenv'; then
	eval "$(rbenv init -)"
fi
test -r /opt/homebrew/bin && eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------------------------------------------
# date command
# ---------------------------------------------


subDate () {
option=''
if [ ! -z $1 ]; then
	option="$option -v $1"
	echo $option
	if [ ! -z $2 ]; then
		option="$option -v $2"
		echo $option
		if [ ! -z $3 ]; then
			option="$option -v $3"
			echo $option
		fi
	fi
	echo $option
	LANG=en_US.UTF-8 date $option '+%a %b %d %T %Y +0900'
else
	echo -e "set option\nexample: -12days => subdate -12d\n         -5days and -13hours => subDate -12d -13H"
fi
}

# ---------------------------------------------
# GUI * CUI
# ---------------------------------------------


alias f='open .'

#cd to the path of the front Finder window
cdf () {
	target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
	if [ "$target" != "" ]; then
    	cd "$target"
		pwd
	else
		echo 'No Finder window found' >&2
	fi
}



# ---------------------------------------------
# Desktop
# ---------------------------------------------


alias fucking-desktop='defaults write com.apple.finder CreateDesktop -boolean false; killall Finder;'
alias sorry-desktop='defaults delete com.apple.finder CreateDesktop; killall Finder;'



# ---------------------------------------------
# for history
# ---------------------------------------------

if [ -n $FILTER_TOOL ] ; then
	# https://qiita.com/yungsang/items/09890a06d204bf398eea

	filter-history() {
		local NUM=$(history | wc -l)
		local FIRST=$((-1*(NUM-1)))
    	if [ $FIRST -eq 0 ] ; then
			history -d $((HISTCMD-1))
			echo "No history" >&2
			return
		fi

		local CMD=$(fc -l $FIRST | sort -k 2 -k 1nr | uniq -f 1 | sort -nr | sed -E 's/^[0-9]+[[:blank:]]+//' | $FILTER_TOOL | head -n 1)

		if [ -n "$CMD" ] ; then
			history -s $CMD

			if type osascript > /dev/null 2>&1 ; then
				(osascript -e 'tell application "System Events" to keystroke (ASCII character 30)' &)
			fi
		else
			history -d $((HISTCMD-1))
		fi
	}
	bind -x '"\C-r": filter-history'

fi
