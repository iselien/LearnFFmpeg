#!/bin/sh

echo "Is it morning ? Please answer yes or no"
read timeofday

case "$timeofday" in
    yes | y | Yes | YES ) 
        echo "Good Morning"
        echo "Up bright and early this morning"
        ;;
    [nN]* ) 
        echo "Good Afternoon"
        ;;
    *) 
        echo "Sorry, answer not recognized"
        exit 1
        ;;
esac

exit 0