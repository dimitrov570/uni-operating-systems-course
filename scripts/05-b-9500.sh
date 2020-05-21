#!/bin/bash

if [ $# -eq 0 -o $# -gt 2 ]; then
		echo "Wrong number of parameters!" >&2
		exit 1
fi

color=

if [ $# -eq 2 ]; then
	case "${1}" in
		"-r")	color="\033[0;31m"
				;;
		"-g")	color="\033[0;32m"
				;;
		"-b")	color="\033[0;34m"
				;;
		   *) 	echo "Unknown colour!"	
			  	exit 2
				;;
	esac
	echo -e "${color}${2}";
else
	echo "${1}";
fi
