#!/bin/bash

if [ $# -ne 1 ]; then
		echo "Wrong number of arguments!" >&2
		exit 1;
fi

user="${1}"

if ! egrep -q "^${user}:" /etc/passwd; then
		echo "User doesn't exist!" >&2
		exit 2;
fi

proportion=0

while read pid vsz rss; do
	if [ $vsz -eq 0 ]; then
		proportion="inf";
	else
		proportion=$(bc <<< "scale=2; ${rss} / ${vsz}")
	fi
	echo "${pid} consumes ${proportion}% of virual memory"
done < <(ps -u "${user}" -o pid=,vsz=,rss=) | sort -nr -k3.2
