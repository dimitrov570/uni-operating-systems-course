#!/bin/bash


while read -p "Enter username: " USERNAME; do

# fgrep with -q option doesn't output nothig, just exits with status 0 if match is found

if [[ -n $USERNAME ]] && fgrep -q "${USERNAME}" /etc/passwd; then		
		nrOfSessions=$(fgrep -c "${USERNAME}" <(who));
		echo "'${USERNAME}' has ${nrOfSessions} active sessions";
else
		echo "'${USERNAME}' is not valid user" >&2;
		exit 1;
fi

done
