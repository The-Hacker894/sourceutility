#!/bin/sh

cp -fv restore_cydia.sh xyz.skylarmccauley.sourceutility/sourceutility/res/
cp -fv restore_sileo.sh xyz.skylarmccauley.sourceutility/sourceutility/res/
cp -fv restore_zebra.sh xyz.skylarmccauley.sourceutility/sourceutility/res/
chmod a+x xyz.skylarmccauley.sourceutility/usr/bin/sourceutility
chmod 0555 xyz.skylarmccauley.sourceutility/DEBIAN/postinst
chmod 0555 xyz.skylarmccauley.sourceutility/DEBIAN/preinst

find . -name ".DS_Store" -delete

dpkg -b xyz.skylarmccauley.sourceutility
