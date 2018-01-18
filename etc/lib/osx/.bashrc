test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install


test -r $HOME/.nodebrew/current/bin && export PATH=$PATH:$HOME/.nodebrew/current/bin
test -r $HOME/.rbenv/bin && export PATH=$HOME/.rbenv/bin:$PATH
if has 'rbenv'; then
	eval "$(rbenv init -)"
fi

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


###########
# Desktop #
###########

alias fucking-desktop='defaults write com.apple.finder CreateDesktop -boolean false; killall Finder;'
alias sorry-desktop='defaults delete com.apple.finder CreateDesktop; killall Finder;'

############
#  unity  ##
############

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
	local unity="$(ls -lr1 /Applications/ | grep Unity | peco)"
	/Applications/$unity/$unity.app/Contents/MacOS/Unity -projectPath "${project_path}" >/dev/null 2>&1 &
}

unirepo () {
	local dir="$(ghq list | peco)"
	if [ ! -z "$dir" ] ; then
		local unity="$(ls -lr1 /Applications/ | grep Unity | peco)"
		/Applications/$unity/$unity.app/Contents/MacOS/Unity -projectPath "$(ghq root)/$dir" >/dev/null 2>&1 &
	fi

}


##################
## init project ##
##################

init-unity-proj() {
	if [ $# -ge 1 ] ; then
		local projectName=$1
		local path="github.com/ryosebach"
		local projPath="$(ghq root)/$path/$projectName"
		local nowDir=`pwd`
		local unity="$(ls -lr1 /Applications/ | grep Unity | peco)"
		/Applications/$unity/$unity.app/Contents/MacOS/Unity -batchmode -quit -createProject "$(ghq root)/$path/$projectName" >/dev/null 2>&1
		cd "$projPath"
		git init  >/dev/null 2>&1
		gibo macos unity windows > .gitignore
		curl -sL raw.github.com/ryosebach/github_template/master/get_template.sh | bash
		cd "$nowDir"
		echo "created $projectName"
	fi
}

###############
## brew cask ##
###############

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
