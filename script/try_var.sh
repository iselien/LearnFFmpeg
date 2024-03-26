#!/bin/sh
salutaion="Hello"
echo $salutaion
echo "The program $0 is now running" 
echo "The second parameter was $2" 
echo "The first parameter was $1" 
echo "The parameter list was $*" 
echo "The user's home directory is $HOME" 

echo "Please enter a new greeting"
read salutaion

echo $salutaion
echo "The script is now complete"
exit 0