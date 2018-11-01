#!/usr/bin/env bash

decode=0
keyFile=~/.ssh/privateKey.txt
while getopts "def:" opt; do
    case "$opt" in
        d)  decode=1;;
        e)  decode=0;;
        f)	keyFile=$OPTARG
            echo "Here";;
        [?]) print >&2 "Usage: $0 [-ed] [-f /path/to/privateKey.txt] inputFile"
            exit 1;;
	esac
done

if [[ ! -z "$ENV_PRIVATE_KEY" ]]; then
    keyFile=$ENV_PRIVATE_KEY
fi

if [[ $decode ]]; then
    openssl rsautl -inkey $keyFile -decrypt <&0
else
    openssl rsautl -inkey $keyFile -encrypt >&1
fi

# openssl rsautl -inkey key.txt -encrypt >output.bin