# GOPATH/bin removed - use Go Modules default $HOME/go/bin instead
export PATH=$PATH:$HOME/go/bin:$HOME/bin
export NODE_PATH=${NVM_PATH}_modules
alias ls='ls --show-control-chars -F --color $*'

if [[ -f ~/.nvm/nvm.sh ]]; then
	source ~/.nvm/nvm.sh
fi
