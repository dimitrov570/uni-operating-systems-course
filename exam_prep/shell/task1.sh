#!/bin/bash

if [ $# -ne 1 ]; then
		echo "Wrong number of arguments!" >&2;
		exit 1;
fi

if [ ! -f ${1} -o ! -r ${1} ]; then
		echo "File not regular or readable!" >&2;
		exit 2;
fi

cat ${1} | egrep "[02468]" | egrep -v "[a-w]" | wc -l;
