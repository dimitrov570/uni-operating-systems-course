#!/bin/bash

read -p "Insert string: " string
if [[ -n $string  && $string =~ [[:alnum:]]+ ]]; then
		echo "Hello, $string";
else
		echo "Wrong input!";
fi
