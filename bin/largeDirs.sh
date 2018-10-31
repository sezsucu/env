#!/usr/bin/env bash

# A script to show the largest directories in the given directory or the current directory
# The size of a directory is computed such that only its direct files
# are considered, not its sub-directories. This is quite easy to do on linux
# using 'du -S . | sort -nr | head -15' but on mac it is not that easy.
# Quite slow on mac though

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

declare -a sizes
declare -a names
limit=10
function computeDir()
{
    local path=$1
    local totalSize=0
    local fileSize=0
    totalSize=$(find "$path" -type f -maxdepth 1 -print0 | xargs -0 stat -f%z | awk '{b+=$1} END {print b}')
    # local is very important here
    local i
    if [[ $totalSize -gt 0 ]]; then
        if [[ ${#sizes[@]} -lt $limit ]]; then
            sizes+=($totalSize)
            names+=("$totalSize $path")
        else
            for (( i=0 ; i < ${#sizes[@]} ; i++ )); do
                if [[ ${sizes[$i]} -lt $totalSize ]]; then
                    sizes[$i]=$totalSize
                    names[$i]="$totalSize $path"
                    i=100000
                fi
            done
        fi
    fi

    # the only way to process files with whitespace in its names
    local filesStr=$(find "$path" -type d -maxdepth 1)
    local files
    IFS=$'\n' read -rd '' -a files <<<"$filesStr"
    for (( i=0 ; i < ${#files[@]} ; i++ )); do
        local file=${files[$i]}
        if [[ "$path" != "$file" ]]; then
            if [ -d "$file" ]; then
                computeDir "$file"
            fi
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
