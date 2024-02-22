#!/bin/bash
cd "$(dirname "$0")" # cd to where the script is located
pwd

if [ "$#" -ne 1 ]; then
    iter=5
else 
    iter=$1
fi
LOG_DIR="./logs/element/"
PARSE="./parse.py"

echo "iter: "$iter


logfile=$LOG_DIR/current.log
temp=$LOG_DIR/temp.log
> $logfile
> $temp

adb logcat -c

for ((i=1; i<=$iter; i++))
do
    
    echo "i="$i
    
    adb shell input tap 540 360 # Enter room
    sleep 2
    
    adb shell input tap 540 1770  # start type
    adb shell input tap 540 1450  # Type G
    adb shell input tap 1010 1000 # Press send

    adb shell input tap 130 180 # Leave room

    sleep 1
    
done
sleep 2

adb logcat -d > $temp
grep 'BM' $temp > $logfile


$PARSE
echo "done"
