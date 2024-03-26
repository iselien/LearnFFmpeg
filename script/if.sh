#!/bin/sh


echo "It is morning? Please answer yes or no"
read timeofday

if [ "$timeofday" = "yes" ]
then 
    echo "Good morning"
elif [ "$timeofday" = "no" ]
then
    echo "Good afternoon"
else
    echo "Sorry, $timeofday nor recognized. Enter yes of no"
    exit 1
fi
exit 0