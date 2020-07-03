#!/bin/bash

if [ $# -ne 1 ]; then
		exit 1;
fi

if [ ! -d $1 ]; then
		exit 2;
fi

find "$1" -type l -printf "%Y %p\n" 2> /dev/null | awk '{if ($1 == "N" || $1 == "L" || $1 == "?") print $2}'
