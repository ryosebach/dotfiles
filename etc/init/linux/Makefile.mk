.PHONY: init apt-update apt-apps ln-apps go-apps other-apps

init: gitconfig apt-update apt-apps ln-apps go-apps other-apps ## Run full initialization

apt-update: ## Update apt sources and packages
	@bash $(DOTPATH)/etc/init/linux/01_app_update.sh

apt-apps: apt-update ## Install packages via apt
	@bash $(DOTPATH)/etc/init/linux/02_apt_install.sh

ln-apps: apt-apps ## Create symlinks for apt packages
	@bash $(DOTPATH)/etc/init/linux/10_ln_apt.sh

go-apps: apt-apps ln-apps ## Install Go-based tools
	@bash $(DOTPATH)/etc/init/linux/04_go_get_install.sh

other-apps: go-apps ## Install other apps (fzf, tig)
	@bash $(DOTPATH)/etc/init/linux/05_other_app_install.sh
