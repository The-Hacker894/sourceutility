#!/bin/sh

clear
VER="1.0"
echo "sourceutility restore_zebra v$VER"

DIRECTORY=`dirname $0`
ZEBRADIR="/private/var/mobile/Documents/xyz.willy.Zebra"
ZEBRABACKUPDIR="./zebra"

ZEBRABUNDLEID="xyz.willy.zebra"

# Checking for Zebra installation
echo "Checking for Zebra installation..."
dpkg-query -W -f='${Status}\n' "$ZEBRABUNDLEID" | grep 'install ok' &> /dev/null
        if [ ! $? == 0 ]; then
                read -p "Zebra is not installed. Do you still wish to continue? [Y/N]" -n 1 -r
                echo
                if ! [[ $REPLY =~ ^[Yy]$ ]]; then
                exit 1;
                fi
        fi

killall Zebra

cd $DIRECTORY

echo "Restoring Zebra backup..."
if [ ! -d $ZEBRADIR ]; then
    mkdir $ZEBRADIR
fi
cp -afv "$ZEBRABACKUPDIR/." $ZEBRADIR
echo "Finished restoring Zebra sources!"
exit 0;