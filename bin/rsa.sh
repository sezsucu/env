#!/usr/bin/env bash

function getFileName()
{
    keyFile=$1
    if [[ $# == 0 ]]; then
        if [[ -d ~/.ssh ]]; then
            keyFile=~/.ssh/privateKey.pem
            if [[ -e ~/.ssh/privateKey.pem ]]; then
                i=1
                keyFile=~/.ssh/privateKey$i.pem
                while [[ -e ~/.ssh/privateKey${i}.pem ]]; do
                    ((i++))
                    keyFile=~/.ssh/privateKey$i.pem
                done
            fi
        else
            keyFile="privateKey.pem"
        fi
    fi

    if [[ ! $keyFile =~ \. && ! $keyFile =~ \/ ]]; then
        keyFile=~/.ssh/privateKey_$keyFile.pem
    fi

    echo $keyFile
}

function extractPublicRSAKey()
{
    keyFile=$(getFileName "$1")
    (>&2 echo "Using $keyFile")
    openssl rsa -in "$keyFile" -pubout
}

function createRSAKey()
{
    keyFile=$(getFileName "$1")
    openssl genrsa -out $keyFile 3072
    chmod 600 $keyFile
    echo "Generated $keyFile"
}

command=$1
shift

case "$command" in
    create)
        createRSAKey "$*"
        ;;
    public)
        extractPublicRSAKey "$*"
        ;;

esac
