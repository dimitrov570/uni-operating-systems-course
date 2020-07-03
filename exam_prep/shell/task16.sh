#!/bin/bash

[ $# -ne 3 ] && exit 1;

[ ! -f "${1}" ] && exit 2;

file="${1}"
k1="${2}"
k2="${3}"

line1=$(grep "^${k1}=" "${file}")
line2=$(grep "^${k2}=" "${file}")

if [ ${#line2} -eq 0 ]; then
		exit 3;
fi

val1=$(echo "${line1}" | cut -d '=' -f 2- | tr ' ' '\n' | sort)
val2=$(echo "${line2}" | cut -d '=' -f 2- | tr ' ' '\n' | sort)

newVal=$(comm <(echo -e "${val1}") <(echo -e "${val2}") -13 | tr '\n' ' ')

sed -i -E "s/^(${k2}=).*/\1$newVal/" "${1}"
