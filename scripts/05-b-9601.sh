#!/bin/bash

backupDir=$BACKUP_DIR

if [ $# -eq 0 -o $# -gt 2 ]; then
		echo "Wrong number of parameters!" >&2;
		exit 1;
fi

if [ $# -eq 1 ]; then
		if [ "${1}" = "-l" ]; then
				while read file dateDeleted; do
				fileName=$(echo "${file}" | rev | cut -d '_' -f 2- | rev);
				echo -e "${fileName}\t${dateDeleted}"
				done < <(find "${backupDir}" -mindepth 1 -printf "%f %TY/%Tm/%Td %Tk:%TM:%.2TS\n")
				exit 0;
		else
			echo "${1} is not a valid option!" >&2;
			exit 2;
		fi
fi

fileName="${1}"
destination="${2}"
backupContent=$(ls -A "${backupDir}")

if [ ! -d "${destination}" -o ! -w "${destination}" -o ! -x "${destination}" ]; then
		echo "Destination directory doesn't exist or is not accessible!" >&2;
		exit 3;
fi

nrOfFiles=$(fgrep -c "${fileName}" < <(echo "${backupContent}")) 

if [ ${nrOfFiles} -eq 1 ]; then
		fullName=$(fgrep "${fileName}"  < <(echo "${backupContent}"))
		realName=$(echo "${fullName}" | rev | cut -d '_' -f 2- | rev)
		if [ "${fileName}" = "${realName}" ]; then #checking if given argument matches the whole file name in backup directory
			fileToRecover=${fullName};
		fi
else
		suggestion=$(fgrep "${fileName}" < <(echo "${backupContent}") | awk 'BEGIN { count=1 }; { printf "%-4s\t%s\n", count, $1; count=count+1; }')
		echo "${suggestion}";
		read -p "Please select file from the list above: " lineNumber;
		if [ ${lineNumber} -lt 1 -o ${lineNumber} -gt ${nrOfFiles} ]; then
				echo "Out of range!" >&2
				exit 10;
		else
				fileToRecover=$(echo "${suggestion}" | sed -n "${lineNumber}p" | cut -f 2);
				realName=$(echo ${fileToRecover} | rev | cut -d '_' -f 2- | rev);
		fi
fi

if [[ "${fileToRecover}" =~ ^.*\.tgz$ ]]; then
		tar -xzf "${backupDir}/${fileToRecover}" -C "${destination}";
elif [[ "${fileToRecover}" =~ ^.*\.gz$ ]]; then
		gunzip -c "${backupDir}/${fileToRecover}" > "${destination}/${realName}";
fi
