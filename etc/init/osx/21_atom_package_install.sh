AtomPackage=(
language-plantuml
plantuml-viewer
linter
Sublime-Style-Column-Selection
)

for app in ${AtomPackage[@]}; do
  apm install $app
done
