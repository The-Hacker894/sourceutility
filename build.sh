#!/bin/sh

chmod a+x res/restore_cydia.sh
chmod a+x res/restore_sileo.sh
chmod a+x res/restore_zebra.sh
chmod a+x xyz.skylarmccauley.sourceutility/usr/bin/sourceutility
chmod 0555 xyz.skylarmccauley.sourceutility/DEBIAN/postinst
chmod 0555 xyz.skylarmccauley.sourceutility/DEBIAN/preinst

find . -name ".DS_Store" -delete

dpkg -b xyz.skylarmccauley.sourceutility
