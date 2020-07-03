#!/bin/bash

if [ $# -ne 1 ]; then
		exit 1;
fi

if [ $(id -u) -ne 0 ]; then
		exit 2;
fi

if ! grep -qE "[+-]?[0-9]+$" <(echo ${1}); then
		exit 3;
fi

users=$(ps -e -o user= | sort | uniq)

while read curUser; do
	rssCount=0;
	while read rss1 pid1; do
			rssCount=$(($rssCount + $rss1));
			lastPid=${pid1}
	done < <(ps -u "${curUser}" -o rss=,pid= | sort -n)
	echo $curUser $rssCount;

	if [ $rssCount -gt $1 ]; then
			kill -s TERM "${lastPID}"
			sleep 1
			kill -s KILL "${lastPID}"
	fi

done < <(echo -e "${users}")
