#!/bin/bash

logfile="./logs/element/current.log"
csvfile="./logs/element/current.csv"

adb logcat -d > $logfile

echo "Timestamp,Start Time (ms),End Time (ms),Elapsed Time (ms)" > "$csvfile"

# Use awk to parse the log 
awk '{
    if ($0 ~ /\[BM\] sendTextMessage start:/) {
        start=$(NF-1); timestamp=$2 " " $3
    } else if ($0 ~ /sendTextMessage end:/) {
        end=$(NF-1)
    } else if ($0 ~ /sendTextMessage: /) {
        print timestamp "," start "," end "," $(NF-1)
    }
}' "$logfile" >> "$csvfile"

