#!/bin/bash
cd "$(dirname "$0")" # cd to where the script is located
pwd

if [ "$#" -ne 1 ]; then
    iter=5
else 
    iter=$1
fi
LOG_DIR = "./log/match/"

echo "iter: "$iter

temp_logfile=$LOG_DIR/temp.log
logfile=$LOG_DIR/current.log

csvfile=$LOG_DIR/current.csv
echo "Timestamp,Enter Room,Press Send,Leave Room,Log Timestamp,Log Start,Log End,Log Elapsed,Enter2Send,Press2Send" > "$csvfile"

> $logfile
for ((i=1; i<=$iter; i++))
do
    adb logcat -c
    echo "i="$i
    
    enter_room_time=$(gdate +%s%3N)
    
    adb shell input tap 540 360 # Enter room
    sleep 1
    
    adb shell input tap 540 1770  # start type
    adb shell input tap 540 1450  # Type G
    adb shell input tap 1010 1000 # Press send
    press_send_time=$(gdate +%s%3N) 
    timestamp=$(gdate +'%Y-%m-%d %H:%M:%S.%3N')

    adb shell input tap 130 180 # Leave room
    leave_time=$(gdate +%s%3N) 

    sleep 2
    adb logcat -d > $temp_logfile
    # Use awk to parse the log 
    awk -v press_send="$press_send_time" -v enter_room="$enter_room_time" -v ts="$timestamp" -v leave="$leave_time" '{
        if ($0 ~ /\[BM\] sendTextMessage start:/) {
            start=$(NF-1);  timestamp=$1 " " $2;
        } else if ($0 ~ /sendTextMessage end:/) {
            end=$(NF-1)
            delay_enter2send=end-enter_room
            delay_press2send=end-press_send;
        } else if ($0 ~ /sendTextMessage: /) {
            print ts "," enter_room "," press_send "," leave "," timestamp "," start "," end "," $(NF-1) "," delay_enter2send "," delay_press2send
            exit
        }
    }' "$temp_logfile" >> "$csvfile"

    cat "$temp_logfile" >> "$logfile"

    echo $timestamp


    adb logcat -c # clear previous log
    
done

echo "done"
