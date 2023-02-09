#!/bin/bash

root=$PWD

for x in */
do
	echo "********* Updating $x *********" 
	cd $x
	./service.pl stop
	./service.pl start
	cd $root
done
