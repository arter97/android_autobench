#!/bin/bash

REPEAT=20
echo "Testing with $(adb shell cat /proc/version)"

adb shell input keyevent 26 > /dev/null 2>&1
adb shell input keyevent 3  > /dev/null 2>&1

TIME1=$(date +%s%N)
TRY=0

echo
until [[ $TRY == $REPEAT ]]; do
	adb shell input keyevent 26 > /dev/null 2>&1
	adb shell input keyevent 3  > /dev/null 2>&1
	TRY=$(($TRY + 1))
	echo $TRY
done

TIME2=$(date +%s%N)

echo
echo Finished in $(echo "scale=2; x=($TIME2-$TIME1)/1000000000; if(x<1) if(x>0) print 0; x" | bc) seconds
echo Average : $(echo "scale=3; x=($TIME2-$TIME1)/1000000000/$REPEAT; if(x<1) if(x>0) print 0; x" | bc) seconds
