#!/bin/bash

if [ $# -ne 1 -a $# -ne 2 ]; then
		exit 1;
fi

[ -d "$1" -a -r "$1" -a -x "$1" ] || exit 2;

nr=$2

if [ $# -eq 2 ]; then
	find "$1" -printf "%n %p\n" 2> /dev/null | awk -v hlNr="$nr" '$1 >= hlNr { print $2 }';
else
	find "$1" -type l -printf "%Y %p\n" 2> /dev/null | grep -E "^[LN\?]" | cut -d ' ' -f 2-		
fi

