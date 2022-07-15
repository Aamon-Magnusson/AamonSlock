#! /bin/bash

fail() {
	echo "SLOCK install skipped!!!"
	echo -e "Slock should be manually installed\n"
}

helpMenu() {
	echo "usage: ./install.sh [options]"
	echo "options:"
	echo -e "\tnone:\tStandard install prompt (dmenu)"
	echo -e "\n-cli:\tCLI install"
	echo -e "\t-h:\tThis help menu\n"
}

if [ -z $1 ];then
	name=$(echo -e "aamonm" | dmenu -p "Enter your username:" -l 2 )
	group=$(echo -e "aamonm\nwheel" | dmenu -p "Enter your group name:" -l 3 )

	color=$(echo -e "pink\ndracula\nwhite\nblue" | dmenu -p "What color scheme would you like dwm to follow?" -i )
	[[ "$color" == "" ]] && color="pink"
elif [ "$1" == "-cli" ];then
	echo -e "\nPlease enter your username:"
	read name
	echo -e "\nPlease enter your group name:"
	read group

	echo "1) pink"
	echo "2) dracula"
	echo "3) white"
	echo "4) blue"
	echo "From the colors above select the number you would like to use."
	read index
	case $index in
		1)
			color="pink" ;;
		2)
			color="dracula" ;;
		3)
			color="white" ;;
		4)
			color="blue" ;;
		*)
			color="pink" ;;
	esac
elif [ "$1" == "-h" ];then
	helpMenu
	exit 0
elif [ "$2" == "-cli" ];then
	echo -e "\nPlease enter your username:"
	read name
	echo -e "\nPlease enter your group name:"
	read group

	color=$1
else
	name=$(echo -e "aamonm" | dmenu -p "Enter your username:" -l 2 )
	group=$(echo -e "aamonm\nwheel" | dmenu -p "Enter your group name:" -l 3 )
	color=$1
fi

ex=".h"
header="$color$ex"

if [ "$name" == "" ] || [ "$group" == "" ];then
	fail
else
	sed -i "s/username/$name/g" config.h
	sed -i "s/groupname/$group/g" config.h

	cd colors
	currentColor=$(awk 'NR==1{print $2}' current.h)
	mv current.h $currentColor.h
	mv $header current.h
	cd ..

	sudo make -s install clean
	sed -i "0,/$name/s//username/" config.h
	sed -i "s/$group/groupname/g" config.h
fi
