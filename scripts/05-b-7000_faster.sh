#!/bin/bash

if [ $# -eq 0 ]; then
		exit 1;
fi

read string;

if [ -z "${string}" ]; then
		exit 2;
fi

echo "----------------------------";

if [ $# -eq 1 ]; then
		echo -n "${1}:";	#if only one file is checked fgrep doesn't output it's name
fi
		fgrep -c "${string}" "$@";
