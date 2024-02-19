#!/bin/bash

cd "$(dirname "$0")" # cd to where the script is located
pwd
source ./shared_vars.sh

PACKAGE_NAME=${1:-$DEFAULT_PACKAGE_NAME}
echo "PACKAGE: "$PACKAGE_NAME

cd $AGENT_DIR
pwd

make clean
make

# copy agent to program's private directory
adb push $AGENT_PATH /sdcard/
adb shell <<EOF
run-as $PACKAGE_NAME
cp /sdcard/$AGENT_NAME ./
pwd
ls
exit
EOF

echo "pushed"

# find pid of the program
adb shell ps | grep $PACKAGE_NAME
pid=$(adb shell ps | grep "$PACKAGE_NAME" | tr -s ' ' | cut -d ' ' -f 2)

if [ ! -z "$pid" ]; then
    echo "pid = "$pid
    echo ""
    echo "to attach:"
    echo "adb shell cmd activity attach-agent $pid /data/data/$PACKAGE_NAME/$AGENT_NAME"
    echo ""
    read -r -p "attach agent? [y/n] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        adb shell cmd activity attach-agent $pid /data/data/$PACKAGE_NAME/$AGENT_NAME
        echo "attached"
    else
        echo ""
    fi
else
    echo "No pid found for package: $PACKAGE_NAME"
fi

echo 'done'
