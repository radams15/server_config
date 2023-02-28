#!/bin/bash

root=$PWD

for x in */
do
	echo "********* Container $x *********" 
	cd $x

	if [ $1 == 'update' ]
	then
		./service.pl stop
		./service.pl start
	elif [ $1 == 'stop' ]
	then
		./service.pl stop
	elif [ $1 == 'start' ]
	then
		./service.pl start
	fi

	cd $root
done
