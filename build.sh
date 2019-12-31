#!/bin/sh

chmod a+x res/restore_cydia.sh
chmod a+x res/restore_sileo.sh
chmod a+x res/restore_zebra.sh

# English Init
chmod a+x xyz.skylarmccauley.sourceutility/usr/bin/sourceutility
chmod 0555 xyz.skylarmccauley.sourceutility/DEBIAN/postinst
chmod 0555 xyz.skylarmccauley.sourceutility/DEBIAN/preinst

# Arabic Init
chmod a+x com.gamehacker.sourceutility/usr/bin/sourceutility
chmod a+x com.gamehacker.sourceutility/usr/bin/Sourceutility
chmod a+x com.gamehacker.sourceutility/usr/bin/الخدمات
chmod 0555 com.gamehacker.sourceutility/DEBIAN/postinst
chmod 0555 com.gamehacker.sourceutility/DEBIAN/preinst

find . -name ".DS_Store" -delete

dpkg -b xyz.skylarmccauley.sourceutility
dpkg -b com.gamehacker.sourceutility
