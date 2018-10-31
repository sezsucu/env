#!/usr/bin/env bash

decode=0
fileName=~/.ssh/privateKey.txt
while getopts "def:" opt; do
    case "$opt" in
        d)  decode=1;;
        e)  decode=0;;
        f)	fileName=$OPTARG;;
        [?]) print >&2 "Usage: $0 [-ed] [-f /path/to/privateKey.txt] inputFile"
            exit 1;;
	esac
done

#  openssl rsautl -inkey key.txt -decrypt <output.bin

# openssl rsautl -inkey key.txt -encrypt >output.bin