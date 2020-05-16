#!/bin/bash

if [[ $# -ne 1 ]]; then
		echo "Wrong number of arguments" >&2
		exit 1;
fi

if ! egrep -q "^${1}" /etc/passwd; then
		echo "User with that login name doesn't exist!" >&2;
		exit 2;
fi

while true; do
if (who | egrep -q "${1}"); then
		echo "${1} has just logged in";
		exit 0;
else
		sleep 1;
fi
done
