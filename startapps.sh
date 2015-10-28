#!/bin/bash

echo "Testing with $(adb shell cat /proc/version)"
echo "Please close all apps, go to home-screen and put your device into airplane-mode"
read -n1 -r -p "Press any key to continue..."

adb shell su -c 'echo 3 > /proc/sys/vm/drop_caches'

TIME1=$(date +%s%N)

echo
echo "Testing with $(cat activities.txt | wc -l) apps"
echo
cat activities.txt | while read activity; do
	adb shell am start -W -n $activity
	echo Finished starting $activity
done

TIME2=$(date +%s%N)

echo
echo Finished in $(echo "scale=2; x=($TIME2-$TIME1)/1000000000; if(x<1) if(x>0) print 0; x" | bc) seconds
