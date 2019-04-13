#!/bin/sh
clear
VER="1.0"
echo "sourceutility restore_sileo v$VER"

DIRECTORY=`dirname $0`

SOURCELISTS="/private/etc/apt/sources.list.d"
CACHEDIR="/private/var/mobile/Library/Caches/"

SILEOSOURCENAME="sileo.sources"
SILEOSOURCELISTCACHE="$CACHEDIR/$SILEOSOURCENAME"
SILEOSOURCELIST="/private/etc/apt/sources.list.d/$SILEOSOURCENAME"

SILEOLISTCACHEBACKUP="./sileocache/$SILEOSOURCENAME"
SOURCELISTSBACKUP="./sourcelists/$SILEOSOURCENAME"

if [[ $EUID -ne 0 ]]; then
        echo "Please run this script as root!" 
        exit 1;
fi

# Change directory to directory of current shell script
cd $DIRECTORY

killall Sileo

# Restoring backup
echo "Copying Sileo Source Cache to $CACHEDIR ..."
cp -fv $SILEOLISTCACHEBACKUP $CACHEDIR
echo "Copying Sileo Source List to $SOURCELISTS ..."
cp -fv $SOURCELISTSBACKUP $SOURCELISTS
echo "Finished restoring Sileo Sources!"

echo "Updating sources..."
apt-get update

echo "Done!"

exit 0;