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
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Usage: rsa.sh public /path/to/privateKey.file"
        exit 1
    fi
    keyFile=$(getFileName "$1")
    (>&2 echo "Using $keyFile")
    openssl rsa -in "$keyFile" -pubout
}

function createRSAKey()
{
    keyFile=$(getFileName "$1")
    openssl genrsa -out $keyFile 4096
    chmod 600 $keyFile
    echo "Generated $keyFile"
}

function encryptData()
{
    keyFile=$(getFileName "$1")
    (>&2 echo "Using $keyFile")
    read -r line < "$keyFile"
    if [[ "$line" =~ .*PRIVATE.* ]]; then
        openssl rsautl -inkey $keyFile -encrypt >&1
    elif [[ "$line" =~ .*PUBLIC.* ]]; then
        openssl rsautl -inkey $keyFile -pubin -encrypt >&1
    fi
}

function decryptData()
{
    keyFile=$(getFileName "$1")
    (>&2 echo "Using $keyFile")
    openssl rsautl -inkey $keyFile -decrypt <&0
}

function signData()
{
    keyFile=$(getFileName "$1")
    (>&2 echo "Using $keyFile")
    openssl dgst -sha256 -sign $keyFile <&0
}

function verifyData()
{
    keyFile=$(getFileName "$1")
    sigFile="$2"
    (>&2 echo "Using $keyFile")
    openssl dgst -sha256 -verify $keyFile -signature $sigFile <&0
}

command=$1
shift

case "$command" in
    cre*)
        createRSAKey "$*"
        ;;

    pub*)
        extractPublicRSAKey "$*"
        ;;

    enc*)
        encryptData "$*"
        ;;

    dec*)
        decryptData "$*"
        ;;

     sig*)
        signData "$*"
        ;;

     ver*)
        verifyData $*
        ;;
    *)
        echo "rsa.sh [(cre)ate] [/path/to/privateKey.file]"
        echo "rsa.sh [(pub)lic] /path/to/privateKey.file"
        echo "rsa.sh [(enc)rypt|(dec)rypt] privateKey.file"
        echo "rsa.sh [(sig)n] [/path/to/privateKey.file] < originalFile > signature.file"
        echo "rsa.sh [(ver)ify] publicKey.file signature.file < originalFile"
esac
