#!/bin/bash

recursive=0
backupDir=${BACKUP_DIR}

if [ -z "${backupDir}" -o ! -d "${backupDir}" -o\
		! -w "${backupDir}" -o ! -x "${backupDir}" ]; then
		echo "\$BACKUP_DIR must contain writable directory!"; >&2;
		exit 1;
fi

if [ "${1}" = "-r" ]; then
		recursive=1;
		shift
fi

while [ -n "${1}" ]; do
		curDate=$(date +"%F-%H-%M-%S");
		if [ -d "${1}" ]; then
				if [ $(ls -A "${1}" | wc -l) -eq 0 ]; then #can handle directory names with whitespace characters in names
						tar czf "${backupDir}/${1}_${curDate}.tgz" "${1}"
						rmdir "${1}";
						echo "[$(date +"%F %H:%M:%S")] Removed directory ${1}"; 
				elif [ "${recursive}" -eq 1 ]; then
						tar czf "${backupDir}/${1}_${curDate}.tgz" "${1}"
						rm -r "${1}";
						echo "[$(date +"%F %H:%M:%S")] Removed directory recursively ${1}"; 
				else
						echo "error: ${1} is not empty, will not be deleted!" >&2;
				fi
		elif [ -f "${1}" ]; then
				gzip -c "${1}" > "${backupDir}/${1}_${curDate}.gz"
				rm "${1}";
				echo "[$(date +"%F %H:%M:%S")] Removed file ${1}"; 
		fi
		shift
done
