#!/bin/sh
clear
VER="1.0~1"
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
# Checking for Sileo installation
echo "Checking for Sileo installation..."
dpkg-query -W -f='${Status}\n' "org.*.sileo" | grep 'install ok' &> /dev/null
        if [ ! $? == 0 ]; then
                read -p "Sileo is not installed. Do you still wish to continue? [Y/N]" -n 1 -r
                echo
                if ! [[ $REPLY =~ ^[Yy]$ ]]; then
                exit 1;
                fi
        fi
# Restoring backup
if [ -r $SILEOLISTCACHEBACKUP ]; then
        echo "Copying Sileo Source Cache to $CACHEDIR ..."
        cp -afv "$SILEOLISTCACHEBACKUP/." $CACHEDIR
fi
if [ -r $SOURCELISTSBACKUPDIR ]; then
        if [ ! -d $SOURCELISTS ]; then
        mkdir $SOURCELISTS
        fi
        echo "Copying Sileo Source List to $SOURCELISTS ..."
        cp -afv "$SOURCELISTSBACKUPDIR/." $SOURCELISTS
fi
echo "Finished restoring Sileo Sources!"

echo "Updating sources..."
apt-get update

echo "Done!"

exit 0;