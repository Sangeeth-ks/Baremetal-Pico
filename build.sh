#!/bin/bash

echo "Please select the project for build"
echo "00 - Blinker "
read input

# Build Blinker program
if [[ $input == "0" ]];then
make Blinker
fi


