export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/bin
export NODE_PATH=${NVM_PATH}_modules
alias ls='ls --show-control-chars -F --color $*'

if [[ -f ~/.nvm/nvm.sh ]]; then
	source ~/.nvm/nvm.sh
fi
