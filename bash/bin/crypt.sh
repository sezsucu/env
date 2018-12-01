#!/usr/bin/env bash

#function getFileName()
#{
#    keyFile=$1
#    if [[ $# == 0 ]]; then
#        if [[ -d ~/.ssh ]]; then
#            keyFile=~/.ssh/privateKey.pem
#            if [[ -e ~/.ssh/privateKey.pem ]]; then
#                i=1
#                keyFile=~/.ssh/privateKey$i.pem
#                while [[ -e ~/.ssh/privateKey${i}.pem ]]; do
#                    ((i++))
#                    keyFile=~/.ssh/privateKey$i.pem
#                done
#            fi
#        else
#            keyFile="privateKey.pem"
#        fi
#    fi
#
#    if [[ ! $keyFile =~ \. && ! $keyFile =~ \/ ]]; then
#        keyFile=~/.ssh/privateKey_$keyFile.pem
#    fi
#
#    echo $keyFile
#}

function extractPublicRSAKey()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Usage: crypt.sh public /path/to/privateKey.file"
        exit 1
    fi
    #keyFile=$(getFileName "$1")
    keyFile=$1
    (>&2 echo "Using $keyFile")
    openssl rsa -in "$keyFile" -pubout
}

function createRSAKey()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Usage: crypt.sh create /path/to/privateKey.pem"
        exit 1
    fi
    keyFile=$1
    if [[ -e "$keyFile" ]]; then
        echo "ERROR: File already exists '$keyFile'"
        exit 1
    fi
    openssl genrsa -out $keyFile 4096
    chmod 600 $keyFile
    echo "Generated $keyFile"
}

function encryptData()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        openssl enc -aes-256-cbc -salt -base64 <&0 >&1
    elif [[ $# == 1 ]]; then
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
    else
        echo "Usage: crypt.sh enc [privateKey.file|publicKey.file|key.file] < input > output"
    fi
}

function decryptData()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        openssl enc -d -aes-256-cbc -base64 <&0 >&1
    elif [[ $# == 1 ]]; then
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
    else
        echo "Usage: crypt.sh dec [privateKey.file|key.file] < input > output"
    fi
}

function signData()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Usage: crypt.sh sign /path/to/privateKey.file"
        exit 1
    fi
    keyFile=$1
    (>&2 echo "Using $keyFile")
    openssl dgst -sha256 -sign $keyFile <&0
}

function verifyData()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Usage: crypt.sh verify /path/to/privateKey.file "
        exit 1
    fi
    keyFile="$1"
    sigFile="$2"
    (>&2 echo "Using $keyFile")
    openssl dgst -sha256 -verify $keyFile -signature $sigFile <&0
}

function addPassword()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Usage: crypt.sh verify /path/to/privateKey.file "
        exit 1
    fi
    keyFile=$1
    (>&2 echo "Using $keyFile")
    openssl rsa -aes256 -in $keyFile >&1
}

function removePassword()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Usage: crypt.sh verify /path/to/privateKey.file "
        exit 1
    fi
    keyFile=$1
    (>&2 echo "Using $keyFile")
    openssl rsa -in $keyFile >&1
}

function generateKey()
{
    if [[ $# == 0 || "$1" == "" ]]; then
        echo "Usage: crypt.sh (gen)erate 32"
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
        echo "crypt.sh (cre)ate /path/to/privateKey.pem"
        echo "creates a private key"
        echo "crypt.sh (pub)lic /path/to/privateKey.file > publicKey.txt"
        echo "extracts the public key from the private key"
        echo "crypt.sh ((enc)rypt|(dec)rypt) (privateKey.pem|publicKey.txt)"
        echo "encrypts or decrypts a small message with a private or public key"
        echo "crypt.sh [(sig)n] /path/to/privateKey.file < originalFile > signature.file"
        echo "creates a signature"
        echo "crypt.sh (ver)ify /path/to/publicKey.file signature.file < originalFile"
        echo "verifies the signature"
        echo "crypt.sh (add) /path/to/privateKey.without.password > passwordProtectedPrivate.file"
        echo "add a password to an existing key"
        echo "crypt.sh (rem)ove /path/to/passwordProtectedPrivate.file > privateKey.without.password"
        echo "remove a password from a key"
        echo ""
        echo "crypt.sh (gen)erate n > secretKey.txt"
        echo "generate random n-byte key"
        echo "crypt.sh (enc)rypt secretKey.txt < bigMessage.txt > enc.bin"
        echo "encrypts any size message using aes256"
        echo "crypt.sh (dec)rypt secretKey.txt < enc.bin > mesg.txt"
esac
