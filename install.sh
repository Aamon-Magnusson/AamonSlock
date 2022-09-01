#! /bin/bash

fail() {
	echo "SLOCK install skipped!!!"
	echo -e "Slock should be manually installed\n"
}

helpMenu() {
	echo "usage: ./install.sh [options]"
	echo "options:"
	echo -e "\tnone:\tStandard install prompt (dmenu)"
	echo -e "\t-h:\tThis help menu\n"
}

if [ -z $1 ];then
	name=$(echo -e "aamonm" | fzf --height=10 --border=rounded --prompt=">" --header="Enter your username:" --header-first --reverse --print-query )
	group=$(echo -e "aamonm\nwheel" | fzf --height=10 --border=rounded --prompt=">" --header="Enter your groupname:" --header-first --reverse --print-query )

	color=$(echo -e "pink\ndracula\nwhite\nblue" | fzf --height=10 --border=rounded --prompt=">" --header="What colorscheme would you like Slock to follow?" --header-first --reverse )
	[[ "$color" == "" ]] && color="pink"
elif [ "$1" == "-h" ];then
	helpMenu
	exit 0
else
	name=$(echo -e "aamonm" | fzf --height=10 --border=rounded --prompt=">" --header="Enter your username:" --header-first --reverse --print-query )
	group=$(echo -e "aamonm\nwheel" | fzf --height=10 --border=rounded --prompt=">" --header="Enter your groupname:" --header-first --reverse --print-query )

	color=$1
fi

if [ $(echo -e "$name" | awk 'FNR == 2 {print}') ]; then
	name=$(echo -e "$name" | awk 'FNR == 2 {print}')
else
	name=$(echo -e "$name" | awk 'FNR == 1 {print}')
fi

if [ $(echo -e "$group" | awk 'FNR == 2 {print}') ]; then
	group=$(echo -e "$group" | awk 'FNR == 2 {print}')
else
	group=$(echo -e "$group" | awk 'FNR == 1 {print}')
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
