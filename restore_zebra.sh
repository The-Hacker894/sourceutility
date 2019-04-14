#!/bin/sh

clear
VER="1.0"
echo "sourceutility restore_zebra v$VER"

DIRECTORY=`dirname $0`
ZEBRADIR="/private/var/mobile/Documents/xyz.willy.Zebra"
ZEBRABACKUPDIR="./zebra"

killall Zebra

cd $DIRECTORY

echo "Restoring Zebra backup..."
if [ ! -d $ZEBRADIR ]; then
    mkdir $ZEBRADIR
fi
cp -afv "$ZEBRABACKUPDIR/." $ZEBRADIR
echo "Finished restoring Zebra sources!"
exit 0;