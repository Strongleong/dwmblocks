#!/bin/sh

ICONl=" " # icon for normal temperatures
ICONn=" " # icon for normal temperatures
ICONc=" " # icon for critical temperatures

crit=70 # critical temperature
norm=40 # normal temperatures

read -r temp </sys/class/thermal/thermal_zone1/temp
temp="${temp%???}"

if [ "$temp" -lt "$norm" ] ; then
    printf "$ICONl%s°C" "$temp"
elif [ "$temp" -lt "$crit" ] ; then
    printf "$ICONn%s°C" "$temp"
else
    printf "$ICONc%s°C" "$temp"
fi
