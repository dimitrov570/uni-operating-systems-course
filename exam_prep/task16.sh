#!/bin/bash

[ $# -ne 3 ] && exit 1;

[ ! -f "${1}" ] && exit 2;

file="${1}"
k1="${2}"
k2="${3}"

line1=$(grep "^${k1}=" "${file}")
line2=$(grep "^${k2}=" "${file}")

val1=$(echo "${line1}" | cut -d '=' -f 2- | tr ' ' '\n' | sort | tr '\n' ' ')
val2=$(echo "${line2}" | cut -d '=' -f 2- | tr ' ' '\n' | sort | tr '\n' ' ')

newVal2=$(comm)

echo ${val1}
echo ${val2}
