#!/bin/bash

user_home=$(mktemp)

cat /etc/passwd | cut -d ':' -f1,6 | tr ':' ' ' > "${user_home}"
minTime=0;
while read usr hmDir; do
		if [ ! -d "$hmDir" -o ! -r "$hmDir" -o ! -x "$hmDir" ]; then
				continue;
		fi

		minFile=$(find "${hmDir}" -type f -printf "%T@ %p\n" 2> /dev/null | sort -n -r | head -n 1)
		if [ -z "$minFile" ]; then
				continue
		fi
		fileTime=$(echo "$minFile" | cut -d ' ' -f 1)
		#echo ${fileTime} ${minTime}
		if [ $(echo "${fileTime}>${minTime}" | bc -l) -eq 1 ]; then
				minTime=$fileTime;
				result=$minFile;
		fi
done < "${user_home}"

echo $result;

rm -- "${user_home}"
