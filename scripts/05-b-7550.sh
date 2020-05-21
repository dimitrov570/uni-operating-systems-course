#!/bin/bash

if [ $(id -u "$(whoami)") -ne 0 ]; then
		echo "Root privileges expected!" >&2
		exit 100;
fi

if [ $# -ne 1 ]; then
	echo "Wrong number of arguments!" >&2
	exit 1;
fi

if ! egrep -q "^${1}:" /etc/passwd; then
		echo "User doesn't exist!" >&2;
		exit 2;
fi

nrOfProcesses=0

while read pid; do
kill -15 ${pid};
sleep 2
kill -9 ${pid};
((++nrOfProcesses))
done < <(ps -u "${1}" -o pid=)
