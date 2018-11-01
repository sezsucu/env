#!/usr/bin/env bash

keyFile=$1
if [[ $# == 0 ]]; then
    if [[ -d ~/.ssh ]]; then
        keyFile=~/.ssh/privateKey.txt
        if [[ -e ~/.ssh/privateKey.txt ]]; then
            i=1
            keyFile=~/.ssh/privateKey$i.txt
            while [[ -e ~/.ssh/privateKey${i}.txt ]]; do
                ((i++))
                keyFile=~/.ssh/privateKey$i.txt
            done
        fi
    else
        keyFile="privateKey.txt"
    fi
fi

echo "Outputting to $keyFile"
openssl genrsa -out $keyFile 3072
chmod 600 $keyFile

