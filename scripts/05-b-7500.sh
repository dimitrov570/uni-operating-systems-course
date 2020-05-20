#!/bin/bash

RANDOM=$(date +"%S")  #seed RANDOM with seconds from current time

range=100

randomNr=$((RANDOM%${range}))

tries=0;

while true; do

read -p "Guess? "  guess;
((++tries))
if [[ ! ${guess} =~ ^[-]?[[:digit:]]+$ ]]; then
		echo "${guess} is not an integer!";
		continue;
fi

if [ ${guess} -eq ${randomNr} ]; then
		echo "RIGHT! Guessed ${randomNr} in ${tries} tries!";
		break;
elif [ ${guess} -lt ${randomNr} ]; then
		echo "...bigger!";
else
		echo "...smaller!";
fi

done
