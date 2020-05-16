#!/bin/bash

if [ $# -ne 3 ]; then
		echo "3 parameters expected" >&2;
		exit 1;
fi

if [[ ! -f "${1}"  || ! -r "${1}" ]]; then
		echo "File not regular or readable" >&2;
		exit 2;
fi

if ! egrep -qi "${2}" /etc/passwd; then
		echo "User doesn't exist!" >&2
		exit 3;
fi

if [ -n "${2}" ]; then
output="$(egrep  -i "^([^:]*:){4}${2}.*" /etc/passwd | cut -d ':' -f 1,5 | cut -d ',' -f 1)";
nrOfMatches=$(egrep -i "^([^:]*:){4}${2}" /etc/passwd | wc -l);
if [[ nrOfMatches>1 ]]; then
	lineNr=1;
	echo "Choose one from following users: ";
	while read lineRead; do
			echo "${lineNr} -> ${lineRead}";
			lineNr=$((lineNr+1));
	done < <(echo "$output");
	read Answer;
	if [[ ${Answer}>=1 && ${Answer}<${lineNr} ]]; then
			user=$(sed -n "${Answer}p" <(echo "${output}") | cut -d ':' -f 2);
			else
				echo "Error!" >&2;
				exit 4;
			fi
		else
				user=$(echo "${output}" | cut -d ':' -f 2);
		fi
	  echo "${3} ${user}" >> "${1}";
else
		echo "Nickname can't be empty string" <&2;
		exit 4;
fi

