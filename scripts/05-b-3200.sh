#!/bin/bash

while read -p "Enter full directory path: " dir; do
		if [[ -d "${dir}" ]]; then
				nrOfFiles=$(find ${dir} -type f 2> /dev/null | wc -l);
				nrOfDirs=$(find ${dir} -type d 2> /dev/null | wc -l);
				echo "'${dir##*/}' contains ${nrOfFiles} files and ${nrOfDirs} directories";
		else
				echo "${dir} is not a valid directory path! ";
		fi
done

