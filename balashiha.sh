#!/bin/bash

for (( x = 37905 ; x < 37990 ; x += 13 ))
do
    #echo $x
    for (( y = 55800 ; y < 55836 ; y += 5 ))
    do
        #echo "${x} - ${y}"
        #echo "${x} - $(printf %.3f \"\$(($y/1000))\")"
        #printf %.3f $(($y/1000))

        echo "$(($x/1000)).$(($x%1000)) - $(($y/1000)).$(($y%1000))"
    done
done
