test -r ~/.dotfiles/etc/install && . ~/.dotfiles/etc/install

while true; do
	e_header "Please input your github username"
	read githubName
	e_warning "you github username: ${githubName}...OK? (y, N)"
	if yes_or_no; then
		break;
	fi
done
git config --global user.name $githubName

while true; do
	e_header "Please input your gitub email"
	read githubMail
	e_warning "your github mail address: ${githubMail}....OK? (y, N)"
	if yes_or_no; then
		break
	fi
done
git config --global user.email $githubMail
