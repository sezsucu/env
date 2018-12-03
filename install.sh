#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $ROOT_DIR/bash/lib.sh

function doCygwin()
{
    openResource https://git-scm.com/
    openResource https://www.python.org/downloads/windows/
    openResource https://www.virtualbox.org/wiki/Downloads
}

function doWSL()
{
    openResource https://www.virtualbox.org/wiki/Downloads
    echo "Linux stuff"
}

function doLinux()
{
    openResource https://www.virtualbox.org/wiki/Downloads
    echo "Linux stuff"
}

function doMac()
{
    echo "Mac stuff"
    https://www.virtualbox.org/wiki/Downloads
}

case $ENV_PLATFORM in
    Cygwin )
        doCygwin
        ;;
    Linux )
        doLinux
        ;;
    Mac )
        doMac
        ;;
    WSL )
        doWSL
        ;;
esac

read -p "Interested in Java Development? [Y/n]? " answer
case $answer in
    [Nn]* )
        ;;
    * | [Yy]* )
            openResource https://www.java.com/en/download/
            openResource https://www.oracle.com/technetwork/java/javase/downloads/index.html
            openResource https://www.jetbrains.com/idea/download/
        ;;
esac

#
#echo "Interested in Java Development? [Y/n]?"
#select answer in "Yes" "No"; do
#    case $answer in
#        Yes )
#            openResource https://www.java.com/en/download/
#            openResource https://www.oracle.com/technetwork/java/javase/downloads/index.html
#            openResource https://www.jetbrains.com/idea/download/
#            break;;
#        No)
#            break;;
#    esac
#done

#openResource https://www.jetbrains.com/idea/download/
#openResource https://freeware.iconfactory.com/icons
#openResource https://www.java.com/en/download/
#openResource https://www.oracle.com/technetwork/java/javase/downloads/index.html
#exit 1


#open
#exit 1

#function showHelp ()
#{
#    echo "install.sh [-f][-d <installDirName>]"
#    echo "-f: to force to override the existing install directory"
#    echo "-d <installDirName>: to give a non-default name to the installDir."
#    echo "   the default installDirName is 'env'"
#    exit 0
#}
#
#force=0
#installDirName="env"
#while getopts "h?fd:" opt; do
#    case "$opt" in
#    h|\?)
#        showHelp
#        ;;
#    f)
#        force=1
#        ;;
#    d)
#        installDirName=$OPTARG
#        ;;
#    esac
#done
#
#ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#SOURCE_DIR="$ROOT_DIR/env"
#INSTALL_DIR="$HOME/$installDirName"
#SRC_DIR="$HOME/src"
#
#if [ $force -eq 0 ] && [ -d $INSTALL_DIR ]; then
#    echo "Already exists, first remove it: $INSTALL_DIR"
#    exit 1
#fi
#
#echo "Installing to $INSTALL_DIR"
#if [ -d $INSTALL_DIR ]; then
#    echo "Deleting $INSTALL_DIR [y/N]? "
#    read answer
#    if [[ $answer == "y" ]] || [[ $answer == "Y" ]]; then
#        \rm -rf $INSTALL_DIR
#    else
#        echo "Already exists, first remove it: $INSTALL_DIR"
#        exit 1
#    fi
#fi
#\cp -rf $SOURCE_DIR $INSTALL_DIR
#
#
## check if the lastLine is already what we put earlier, otherwise add source line
#lastLine=""
#if [ -f "$HOME/.bashrc" ]; then
#    lastLine=`awk '/./{line=$0} END{print line}' ~/.bashrc`
#fi
#
#if [ "$lastLine" != "source $HOME/$installDirName/bash/start.sh" ]; then
#    echo "Setting up .bashrc"
#
#    echo "export PATH=\"b\$PATH:/usr/local/sbin\"" >> ~/.bashrc
#    echo "" >> ~/.bashrc
#    echo "if [ -e /usr/libexec/java_home ]; then" >> ~/.bashrc
#    echo "    export JAVA_HOME=\`/usr/libexec/java_home\`" >> ~/.bashrc
#    echo "fi" >> ~/.bashrc
#    echo "" >> ~/.bashrc
#    echo "if [ -x \"$(which emacs 2>/dev/null)\" ]; then" >> ~/.bashrc
#    echo "    export EDITOR=emacs" >> ~/.bashrc
#    echo "fi" >> ~/.bashrc
#    echo "" >> ~/.bashrc
#    echo "source $HOME/$installDirName/bash/programming.sh" >> ~/.bashrc
#    echo "source $HOME/$installDirName/bash/start.sh" >> ~/.bashrc
#
#    echo "Added 'source $HOME/$installDirName/bash/start.sh' to ~/bashrc"
#fi
#
## check if we have bashrc and also the special lines that are needed to source from bashrc
#foundIt=0
#if [ -f ~/.bash_profile ]; then
#    while read -r line; do
#        if [[ $line == *"[ -f ~/.bashrc ]"* ]]; then
#            foundIt=1
#        fi
#    done < ~/.bash_profile
#fi
#
#if [ $foundIt -eq 0 ]; then
#    echo "Setting up .bash_profile"
#    echo "if [ -f ~/.bashrc ]; then" >> ~/.bash_profile
#    echo "    source ~/.bashrc" >> ~/.bash_profile
#    echo "fi" >> ~/.bash_profile
#fi
#
#if [ ! -f ~/.hiverc ]; then
#    echo "Installing hiverc since you don't have one"
#    mv $HOME/$installDirName/etc/hiverc $HOME/.hiverc
#    if [ -e $SRC_DIR/brickhouse/target ]; then
#        JAR_FILE_TMP=`ls $SRC_DIR/brickhouse/target/brickhouse*.jar`
#        echo "add jar $JAR_FILE_TMP;" >> ~/.hiverc
#        echo "source $SRC_DIR/brickhouse/src/main/resources/brickhouse.hql;" >> ~/.hiverc
#    fi
#
#    if [ -e $SRC_DIR/hivemall/target ]; then
#        JAR_FILE_TMP=`ls $SRC_DIR/hivemall/target/hivemall-*.*-with-dependencies.jar`
#        echo "add jar $JAR_FILE_TMP;" >> ~/.hiverc
#        echo "source $SRC_DIR/hivemall/scripts/ddl/define-all.hive;" >> ~/.hiverc
#    fi
#fi
#
#echo "Installed to $HOME/$installDirName"
#source $HOME/$installDirName/bash/start.sh