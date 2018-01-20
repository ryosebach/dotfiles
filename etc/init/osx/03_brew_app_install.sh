BrewApp=(
the_platinum_searcher
go
peco
ghq
tig
gibo
wget
nkf
ghostscript
hub
tree
graphviz
)

for app in ${BrewApp[@]}; do
  brew install $app
done
