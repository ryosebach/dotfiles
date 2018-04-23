export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/bin
export NODE_PATH=${NVM_PATH}_modules
alias ls='ls --show-control-chars -F --color $*'

if [[ -f ~/.nvm/nvm.sh ]]; then
	source ~/.nvm/nvm.sh
fi

if has 'fzf'; then
	ssh-add-with-select() {
		local sshFile=$(\ls -1 ~/.ssh | grep -v "\." | grep id | fzf)
		eval `ssh-agent`
		ssh-add ~/.ssh/${sshFile}
		echo "ssh-add ${sshFile}"
	}
fi
