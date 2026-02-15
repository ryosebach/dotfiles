DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .gitignore .github .claude
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

# OS detection
UNAME := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ifeq ($(findstring darwin,$(UNAME)),darwin)
  PLATFORM := osx
else ifeq ($(findstring linux,$(UNAME)),linux)
  PLATFORM := linux
endif

.DEFAULT_GOAL := help

.PHONY: help list deploy update init gitconfig claude

help: ## Show available targets
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

list: ## Show dotfiles in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: claude ## Create symlinks to home directory
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

CLAUDE_CONFIGS := settings.json

claude: ## Link Claude Code config files to ~/.claude/
	@mkdir -p $(HOME)/.claude
	@$(foreach val, $(CLAUDE_CONFIGS), ln -sfnv $(DOTPATH)/.claude/$(val) $(HOME)/.claude/$(val);)

update: ## Fetch changes for this repo
	git pull origin master

gitconfig: ## Setup git user config
	@bash $(DOTPATH)/etc/init/common/01_set_gitconfig.sh

# Include platform-specific targets
-include $(DOTPATH)/etc/init/$(PLATFORM)/Makefile.mk
