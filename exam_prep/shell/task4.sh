#!/bin/bash

if [ $# -ne 2 ]; then
		exit 1;
fi

if [ ! -f $1 -o ! -r $1 -o ! -f $2 -o ! -r $2 ]; then
		exit 2;
fi

firstLineNr=$(cat "${1}" | egrep -c "^(.* )?${1}( .*)?")
secondLineNr=$(cat "${2}" | egrep -c "^(.* )?${2}( .*)?")

if [ ${firstLineNr} -ge ${secondLineNr} ]; then
		winner=${1};
else
		winner=${2};
fi

cat "${winner}" | cut -d '-' -f2- | sed "s/ //" > "${winner}.songs"
