test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install


test -r $HOME/.nodebrew/current/bin && export PATH=$PATH:$HOME/.nodebrew/current/bin
test -r $HOME/.rbenv/bin && export PATH=$HOME/.rbenv/bin:$PATH
if has 'rbenv'; then
	eval "$(rbenv init -)"
fi


# --------------------------------------------- 
# GUI * CUI
# --------------------------------------------- 


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



# --------------------------------------------- 
# Desktop
# --------------------------------------------- 


alias fucking-desktop='defaults write com.apple.finder CreateDesktop -boolean false; killall Finder;'
alias sorry-desktop='defaults delete com.apple.finder CreateDesktop; killall Finder;'


# --------------------------------------------- 
# init project
# --------------------------------------------- 

if [ -n "$FILTER_TOOL" ] ; then
	init-unity-proj() {
		if [ $# -ge 1 ] ; then
			local service=$(\ls -1 $GOPATH/src | $FILTER_TOOL)
			if [ -z "$service" ] ; then
				return
			fi
			local projPath=$(ghq root)/$service/ryosebach/$1
			local nowDir=$(pwd)
			local unity="$(\ls -lr1 /Applications/ | grep Unity | $FILTER_TOOL)"
			if [ -z "$unity" ] ; then
				return
			fi
			/Applications/$unity/$unity.app/Contents/MacOS/Unity -batchmode -quit -createProject $projPath >/dev/null 2>&1
			cd "$projPath"
			git init  >/dev/null 2>&1
			gibo macos unity windows > .gitignore
			curl -sL raw.github.com/ryosebach/github_template/master/get_template.sh | bash
			cd "$nowDir"
			echo "created $1"
		fi
	}
	unirepo () {
		local dir="$(ghq list | $FILTER_TOOL)"
		if [ -n "$dir" ] ; then
			local unity="$(ls -lr1 /Applications/ | grep Unity | $FILTER_TOOL)"
			/Applications/$unity/$unity.app/Contents/MacOS/Unity -projectPath "$(ghq root)/$dir" >/dev/null 2>&1 &
		fi
	
	}
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
		local unity="$(\ls -lr1 /Applications/ | grep Unity | $FILTER_TOOL)"
		/Applications/$unity/$unity.app/Contents/MacOS/Unity -projectPath "${project_path}" >/dev/null 2>&1 &
	}
fi

# --------------------------------------------- 
# brew cask
# --------------------------------------------- 

brew-cask-upgrade(){
	for app in $(brew cask list); do
		local latest="$(brew cask info "${app}" | awk 'NR==1{print $2}')";
		local versions=($(ls -1 "/usr/local/Caskroom/${app}/.metadata/"));
		local current=$(echo ${versions} | awk '{print $NF}');
		if [[ "${latest}" = "latest" ]]; then
			e_warning "[!] ${app}: ${current} == ${latest}";
			[[ "$1" = "-f" ]] && brew cask install "${app}" --force;
			continue;
		elif [[ "${current}" = "${latest}" ]]; then
			e_header "[ok] ${app}: ${current} == ${latest}";
			continue;
		fi;
		e_newline && e_header "[+] ${app}: ${current} -> ${latest}";
		brew cask uninstall "${app}" --force; brew cask install "${app}";
	done;
}



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
