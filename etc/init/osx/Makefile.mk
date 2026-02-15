.PHONY: init brew brew-apps cask-apps other-apps macos app-settings

init: gitconfig brew brew-apps cask-apps other-apps macos app-settings ## Run full initialization

brew: ## Install Homebrew
	@bash $(DOTPATH)/etc/init/osx/02_brew_install.sh

brew-apps: brew ## Install CLI apps via Homebrew
	@bash $(DOTPATH)/etc/init/osx/03_brew_app_install.sh

cask-apps: brew ## Install GUI apps via Homebrew Cask
	@bash $(DOTPATH)/etc/init/osx/04_cask_app_install.sh

other-apps: ## Install other apps (Nodebrew, fonts)
	@bash $(DOTPATH)/etc/init/osx/05_other_app_install.sh

macos: ## Apply macOS system settings (dock, trackpad)
	@bash $(DOTPATH)/etc/init/osx/09_mac_setup.sh

app-settings: ## Apply app-specific settings
	@bash $(DOTPATH)/etc/init/osx/10_app_settings.sh
