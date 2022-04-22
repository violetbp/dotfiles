#!/bin/bash

vol="$(ponymix | grep sink -A 2 | grep Volume | cut -c 16-)"

num="$(echo $vol | sed 's/%//g')"

if [ "$num" == "0" -o "$num" == "5" ]; then
string=""
elif [ "$num" == "10" -o "$num" == "15" ]; then
string="#"
elif [ "$num" == "20" -o "$num" == "25" ]; then
string="##"
elif [ "$num" == "30" -o "$num" == "35" ]; then
string="###"
elif [ "$num" == "40" -o "$num" == "45" ]; then
string="####"
elif [ "$num" == "50" -o "$num" == "55" ]; then
string="#####"
elif [ "$num" == "60" -o "$num" == "65" ]; then
string="######"
elif [ "$num" == "70" -o "$num" == "75" ]; then
string="#######"
elif [ "$num" == "80" -o "$num" == "85" ]; then
string="########"
elif [ "$num" == "90" -o "$num" == "95" ]; then
string="#########"
elif [ "$num" == "100" ]; then
string="##########"
fi
 
dot="${num: -1}"
 
if [ "$dot" == "5" ]; then
string="$(echo $string"-")"
fi
 
echo $string $num"%"
