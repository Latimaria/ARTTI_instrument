#!/bin/bash

# push.sh
INSTRUMENT_DIR="/Users/account/git_repo/Android/ARTTI_instrument/"
DEFAULT_PACKAGE_NAME="im.vector.app.debug"
INSTRUMENT_PLAN="plan.btm"

# install.sh
APK="vector-gplay-arm64-v8a-debug.apk"
APK_DIR="/Users/account/git_repo/element-android/vector-app/build/outputs/apk/gplay/debug"

# generate_agent.py
CC_DIR='/Users/account/Library/Android/sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/darwin-x86_64/bin'
CFLAGS='-fPIC -shared -static-libstdc++ -llog'
INCLUDES='''-I/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home/include \\
           -I/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home/include/darwin \\
		   -I/Users/account/Library/Android/sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/android'''

# general
AGENT_NAME="libagent.so"

############################

# generated
AGENT_DIR=$INSTRUMENT_DIR"/agent/"
AGENT_PATH=$AGENT_DIR/$AGENT_NAME
LOG_DIR=$INSTRUMENT_DIR"/logs/"

# src
SRC_DIR=$INSTRUMENT_DIR"/src/"
PY_PATH=$SRC_DIR"/generate_agent.py"
PUSH_PATH=$SRC_DIR"/push.sh"

# inputs
PLAN_PATH=$INSTRUMENT_DIR/$INSTRUMENT_PLAN
APK_PATH=$APK_DIR/$APK
