#!/bin/bash

cd "$(dirname "$0")" # cd to where the script is located
pwd
source ./src/shared_vars.sh

extra_args=""

for arg in "$@"; do
    if [[ "$arg" == "-y" ]]; then
        extra_args+="-y " # right now only allow -y
    fi
done

python3 $PY_PATH --cc-dir "$CC_DIR" --cflags "$CFLAGS" --includes "$INCLUDES" -m --output-dir "$AGENT_DIR" --input-file "$PLAN_PATH" $extra_args


bash $PUSH_PATH

