AptApp=(                   
	libncurses5-dev
	build-essential
	golang-1.10-go
)                           

for app in ${AptApp[@]}; do
	sudo apt install $app         
done                        
