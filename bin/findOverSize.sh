#!/usr/bin/env bash

# find all files that are over the given size
# ex: findOverSize 10M
# ex: findOverSize 10M "*.log"
# ex: findOverSize 10k

if [ $# -eq 0 ]; then
    echo 'Usage: findOverSize 10M or findOverSize 10k "*.cc"'
    echo 'Find all files that are over the given size'
fi

# make k,M,G case insensitive, so K, m, g also work
sizeStr=$1
length=${#sizeStr}
((length--))
if [ "${sizeStr:length:1}" = "K" ]; then
    sizeStr=${sizeStr:0:length}"k"
elif [ "${sizeStr:length:1}" = "m" ]; then
    sizeStr=${sizeStr:0:length}"M"
elif [ "${sizeStr:length:1}" = "g" ]; then
    sizeStr=${sizeStr:0:length}"G"
fi
if [ "$ENV_PLATFORM" = "Mac" ]; then
    eval find . -type f -name \"${2:-*}\" -size +$sizeStr -print0 | xargs -n1 -0 ls -lhG;
else
    eval find . -type f -name \"${2:-*}\" -size +$sizeStr -print0 | xargs --no-run-if-empty -n1 -0 ls -lh --color;
fi
