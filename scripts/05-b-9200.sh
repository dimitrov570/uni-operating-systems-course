#!/bin/bash

recursive=0
logFile=$RMLOG_FILE

if [ -z "${logFile}" -o ! -f "${logFile}" -o ! -w "${logFile}" ]; then
		echo "\$RMLOG_FILE must contain writable file path!"; >&2;
		exit 1;
fi

if [ "${1}" = "-r" ]; then
		recursive=1;
		shift
fi

while [ -n "${1}" ]; do
		if [ -d "${1}" ]; then
				if [ $(ls -A "${1}" | wc -l) -eq 0 ]; then
						rmdir "${1}";
						echo "[$(date +"%F %H:%M:%S")] Removed directory ${1}" >> "${logFile}"; 
				elif [ "${recursive}" -eq 1 ]; then
						rm -r "${1}";
						echo "[$(date +"%F %H:%M:%S")] Removed directory recursively ${1}" >> "${logFile}"; 
				fi
		elif [ -f "${1}" ]; then
				rm "${1}";
				echo "[$(date +"%F %H:%M:%S")] Removed file ${1}" >> "${logFile}"; 
		fi
		shift
done
