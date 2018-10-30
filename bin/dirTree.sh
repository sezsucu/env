#!/usr/bin/env bash

# a script to show directory structure
if [[ $# > 1 ]]; then
    echo "Usage: dirTree.sh /path/to/directory ";
    exit 1;
fi

path=$1
if [ $# == 0 ]; then
    path=`pwd`
fi

# remove the last '/' character if there is one
if [[ "$path" =~ .*\/$ ]]; then
    len=${#path}
    ((--len))
    path=${path:0:$len}
fi

function showLevel()
{
    for (( i=0 ; i < $1 ; i++ )); do
        printf "."
    done
}

function showDir()
{
    local path=$1
    local level=$2
    local k=0
    for file in $path/*; do
        if [ -d "$file" ]; then
            showLevel $level
            if (( k > 0 )); then
                echo '|' `basename $file`
            else
                echo '\' `basename $file`
            fi
            showDir $file $((level+1))
            ((k++))
        fi
    done
}

echo $path
showDir $path 1



