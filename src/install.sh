#!/bin/bash

# reinstall im.vector.app.debug to connected device

cd "$(dirname "$0")" # cd to where the script is located
pwd
source ./shared_vars.sh

echo "apk:"
echo $APK_PATH

adb uninstall $DEFAULT_PACKAGE_NAME
adb install $APK_PATH

echo "done"
