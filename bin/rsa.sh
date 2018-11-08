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
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Requires file name"
        exit 1
    fi
    #keyFile=$(getFileName "$1")
    keyFile=$1
    #(>&2 echo "Using $keyFile")
    read -r line < "$keyFile"
    if [[ "$line" =~ .*PRIVATE.* ]]; then
        openssl rsautl -inkey $keyFile -encrypt >&1
    elif [[ "$line" =~ .*PUBLIC.* ]]; then
        openssl rsautl -inkey $keyFile -pubin -encrypt >&1
    else
        openssl enc -aes-256-cbc -salt -base64 -pass file:$keyFile <&0 >&1
    fi
}

function decryptData()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Requires file name"
        exit 1
    fi
    keyFile=$1
    #keyFile=$(getFileName "$1")
    #(>&2 echo "Using $keyFile")
    read -r line < "$keyFile"
    if [[ "$line" =~ .*PRIVATE.* ]]; then
        openssl rsautl -inkey $keyFile -decrypt <&0
    elif [[ "$line" =~ .*PUBLIC.* ]]; then
        openssl rsautl -inkey $keyFile -pubin -decrypt <&0
    else
        openssl enc -d -aes-256-cbc -base64 -pass file:$keyFile <&0 >&1
    fi
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

function addPassword()
{
    keyFile=$(getFileName "$1")
    (>&2 echo "Using $keyFile")
    openssl rsa -aes256 -in $keyFile >&1
}

function removePassword()
{
    keyFile=$(getFileName "$1")
    (>&2 echo "Using $keyFile")
    openssl rsa -in $keyFile >&1
}

function generateKey()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Usage: rsa.sh (gen)erate 32"
        exit 1
    fi
    openssl rand -base64 $1
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

    rem*)
        removePassword $*
        ;;

    add*)
        addPassword $*
        ;;

    gen*)
        generateKey $*
        ;;
    *)
        echo "generate random n-byte key"
        echo "rsa.sh [(gen)erate] n"
        echo "creates a private key"
        echo "rsa.sh [(cre)ate] [/path/to/privateKey.file]"
        echo "extracts the public key from the private key"
        echo "rsa.sh [(pub)lic] /path/to/privateKey.file"
        echo "encrypts or decrypts any size message using aes256"
        echo "rsa.sh [(enc)rypt|(dec)rypt] secretKey.file"
        echo "encrypts or decrypts a small message"
        echo "rsa.sh [(enc)rypt|(dec)rypt] privateKey.file"
        echo "creates a signature"
        echo "rsa.sh [(sig)n] [/path/to/privateKey.file] < originalFile > signature.file"
        echo "verifies the signature"
        echo "rsa.sh [(ver)ify] /path/to/publicKey.file signature.file < originalFile"
        echo "add a password to an existing key"
        echo "rsa.sh [(add)] /path/to/privateKey.without.password > passwordProtectedPrivate.file"
        echo "remove a password from a key"
        echo "rsa.sh [(rem)ove] /path/to/passwordProtectedPrivate.file > privateKey.without.password"
esac
