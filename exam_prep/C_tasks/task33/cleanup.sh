#!/bin/bash

rm tmp1 tmp2

read -p "Do you want to remove output? [Y/N] " answer;

if [ ${answer} = "Y" -o ${answer} = "y" ]; then
	rm output;
fi
