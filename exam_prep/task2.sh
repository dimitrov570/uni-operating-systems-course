#!/bin/bash

[ $# -ne 1 ] && exit 1;

[ ! -f $1 -o ! -r ${1} ] && exit 2;

counter=1
fileContent=$(cat $1 | cut -d '-' -f 2- | awk 'BEGIN{counter=1} {printf "%d.%s\n", counter, $0; counter=counter+1}')
echo -e "${fileContent}" | sort -t '.' -k 2

exit 0;
