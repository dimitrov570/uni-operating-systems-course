#!/bin/bash

if [[ $# == 0 || $# > 1 ]]; then
		echo "Only one parameter needed!" >&2
		exit 1
elif [[ "$1" =~ ^[[:alnum:]]+$ ]]; then
		echo "\"$1\" contains only letters and numbers! "
else
		echo "'$1' doesn't contain only letters and numbers! "
fi
