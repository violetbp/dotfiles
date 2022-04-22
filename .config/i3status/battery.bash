#!/bin/bash

while :
do
	POWER=$(acpi -b | grep "Battery 0" | grep -o '[0-9]\+%' | tr -d '%')
	if [[ $POWER -le 80 ]]; then
		i3-nagbar -t warning -m 'Battery power is lower than 15%!'
	fi
sleep 30
done
