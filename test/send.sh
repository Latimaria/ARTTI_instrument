#!/bin/bash

adb shell input tap 540 360 # enter room
sleep 1
adb shell input tap 540 1770 # start typing
adb shell input tap 540 1450 # type G
adb shell input tap 1010 1000 # press send
adb shell input tap 130 180 # leave room

#!/bin/bash

if [ "$#" -ne 1 ]; then
    iter=2
else 
    iter=$1
fi

output_file="./adb/current.csv"
echo "Timestamp,Enter Room,Press Send" > "$output_file"

for ((i=1; i<=$iter; i++))
do
    adb shell input tap 540 360 # Enter room
    enter_room_time=$(gdate +%s%3N)
    sleep 1
    
    adb shell input tap 540 1770  # start type
   
    adb shell input tap 540 1450  # Type G

    adb shell input tap 1010 1000 # Press send
    press_send_time=$(gdate +%s%3N) 
    timestamp=$(gdate +'%Y-%m-%d %H:%M:%S.%3N')

    adb shell input tap 130 180 # Leave room

    echo "$timestamp,$enter_room_time,$press_send_time" >> "$output_file"
    
    sleep 1
    
done

echo "done"
