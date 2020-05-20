#!/bin/bash

size=0

while read -d ':' arg; do
		if [ -d "${arg}" -a -r "${arg}" -a -x "${arg}" ]; then
				(( size += $(find "${arg}" -type f -executable | wc -l ) ))
		fi
done < <(echo "${PATH}:")
echo "${size}"
