#!/bin/bash

echo "Testing with $(adb shell cat /proc/version)"
echo "Please close all apps, go to home-screen and put your device into airplane-mode"
read -n1 -r -p "Press any key to continue..."

adb shell su -c 'echo 3 > /proc/sys/vm/drop_caches'

echo
echo "Testing with $(cat activities.txt | wc -l) apps"
cat activities.txt | tr '/' ' ' | awk '{print $1}' | while read app; do
	PID=$(adb shell pgrep $app | dos2unix | tr '\n' ' ')
	until [[ -z $PID ]]; do
		echo "Killing $app"
		adb shell su -c "kill -9 $PID" > /dev/null 2>&1
		PID=$(adb shell pgrep $app | dos2unix)
	done
done
echo
adb shell su -c 'echo 3 > /proc/sys/vm/drop_caches'

TIME1=$(date +%s%N)

cat activities.txt | while read activity; do
	adb shell am start -W -n $activity > /dev/null 2>&1
	echo Finished starting $activity
done

TIME2=$(date +%s%N)

echo
echo Finished in $(echo "scale=2; x=($TIME2-$TIME1)/1000000000; if(x<1) if(x>0) print 0; x" | bc) seconds
