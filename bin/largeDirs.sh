#!/usr/bin/env bash

# A script to show the largest directories in the given directory or the current directory
# The size of a directory is computed such that only its direct files
# are considered, not its sub-directories.


source "$ENV_HOME_DIR/bash/lib.sh"

if [[ $# > 1 ]]; then
    echo "Usage: largeDirs.sh /path/to/directory ";
    exit 1;
fi

path=$1
if [ $# == 0 ]; then
    path=`pwd`
fi

if [[ "$path" =~ .*\/$ ]]; then
    len=${#path}
    ((--len))
    path=${path:0:$len}
fi

sizes=(0 0 0 0 0 0 0 0 0)
names=('' '' '' '' '' '' '' '' '' '')
function computeDir()
{
    local path=$1
    local totalSize=0
    local fileSize=0
    #echo $path
    totalSize=$(find "$path" -type f -maxdepth 1 -print0 | xargs -0 stat -f%z | awk '{b+=$1} END {print b}')
#    for file in $path/*; do
#        if [ -f "$file" ]; then
#            if [ "$ENV_PLATFORM" = "Mac" ]; then
#                set -- $(\stat -f%z "$file")
#                fileSize=$1
#            else
#                set -- $(\stat -c%z "$file")
#                fileSize=$1
#            fi
#            ((totalSize+=fileSize))
#        fi
#    done
    #dirs=$(find "$path" -type d -maxdepth 1 -print0 | xargs -0 stat -f%z | awk '{b+=$1} END {print b}')
    #for file in $path/*; do
    for file in $(find "$path" -type d -maxdepth 1 -print0 | xargs -0 echo); do
        if [[ "$path" != "$file" ]]; then
            if [ -d "$file" ]; then
                computeDir "$file"
            fi
        fi
    done
    for (( i=0 ; i < ${#sizes[@]} ; i++ )); do
        if [[ ${sizes[$i]} -lt $totalSize ]]; then
            sizes[$i]=$totalSize
            names[$i]="$totalSize $path"
            i=100000
        fi
    done
}

echo $path
computeDir "$path"
IFS=$'\n' sorted=($(sort -rn <<<"${names[*]}"))

for (( i=0 ; i < ${#sizes[@]} ; i++ )); do
    if [[ ${sizes[$i]} -ne 0 ]]; then
        echo ${sorted[$i]}
    fi
done

