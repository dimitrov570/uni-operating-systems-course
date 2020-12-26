#!/bin/bash
# read-default: supply a default value if user presses Enter key.
read -e -i $USER -p "What is your user name? " 
echo "You answered: '$REPLY'"
