#!/bin/sh


clear
VER="1.0~2"
echo "sourceutility restore_sileo v $VER"

DIRECTORY=`dirname $0`

SOURCELISTS="/private/etc/apt/sources.list.d" # Will need to copy everything from this directory to complete backup
SOURCELISTSBACKUPDIR="./sourcelists"

SOURCELISTSCYDIAD="/private/etc/apt/sources.cydiad" 
SOURCELISTSCYDIADBACKUPDIR="./cydiad"

CACHEDIR="/private/var/mobile/Library/Caches/"

CYDIAPREFNAME="com.saurik.Cydia.plist"
PREFSDIR="/private/var/mobile/Library/Preferences"
CYDIAPREFSBACKUPDIR="./cydiaprefs"
CYDIAPREFSBACKUP="$CYDIAPREFSBACKUPDIR/$CYDIAPREFNAME"

CYDIACACHEDIR="/private/var/mobile/Library/Caches/com.saurik.Cydia"
CYDIASOURCESCACHE="$CYDIACACHEDIR/sources.list"
CYDIALISTCACHE="$CYDIACACHEDIR/lists"
CYDIACACHEBACKUPDIR="./cache"

SILEOSOURCENAME="sileo.sources"
SILEOSOURCELIST="/private/etc/apt/sources.list.d/$SILEOSOURCENAME"


if [[ $EUID -ne 0 ]]; then
        echo "Please run this script as root!" 
        exit 1;
fi

# Change directory to directory of current shell script
cd $DIRECTORY

killall Cydia

# Restoring backup
echo "Copying Cydia Preferences Backup to $PREFSDIR"
cp -rfv $CYDIAPREFSBACKUP $PREFSDIR
echo "Removing target Cydia Cache files..."
rm -rf "$CYDIACACHEDIR/lists"
rm -rf "$CYDIACACHEDIR/sources.list"
echo "Copying Cydia Cache Backup to $CYDIACACHEDIR"
cp -afv "$CYDIACACHEBACKUPDIR/." "$CYDIACACHEDIR/"
if [ ! -d $SOURCELISTS ]; then
mkdir $SOURCELISTS
fi
echo "Copying Source List Backup to $SOURCELISTS"
cp -afv "$SOURCELISTSBACKUPDIR/." "$SOURCELISTS/"

if [ "$(ls -A $SOURCELISTSCYDIADBACKUPDIR)" ]; then
## Not Empty
echo "Copying sources.cydiad Backups to $SOURCELISTSCYDIAD"
cp -afv "$SOURCELISTSCYDIADBACKUPDIR/." $SOURCELISTSCYDIAD
else
## Empty
echo "$SOURCELISTSCYDIADBACKUPDIR is either empty or does not exist. Continuing with restore!"
fi
echo "Finished restoring Cydia Sources!"
pause

erase_tmp() {
        echo "Cleaning up..."
        rm tmp/
}
reinstall_cydia() {
    
    mkdir tmp/
    cd tmp/
    check_if_root
    killall Cydia
    killall SIleo
    echo "Checking for tmp directory..."
    
    REPO_U0="https://apt.bingner.com"
    REPO_EL="https://electrarepo64.coolstar.org"
    CYDIADL_U0="$REPO_U0/debs/1443.00/cydia_1.1.32~b12_iphoneos-arm.deb"
    CYDIADL_EL="$REPO_EL/debs/cydia_2.1-1_iphoneos-arm.deb"
    
    u0() {
        check_connection $REPO_U0
        echo "Downloading Cydia from $CYDIADL_U0..."
        curl -o ./cydia.deb $CYDIADL_U0
        echo "Attempting to install Cydia..."
        echo "Running dpkg..."
        dpkg -i ./cydia.deb
        echo "Running uicache... (this may take some time)"
        uicache
        echo "Cleaning up..."
        rm -f ./cydia.deb
        cd /
        echo "Completed installation process for Cydia. You may want to run ldrestart after this script has concluded. If Cydia did not install or install correctly, Re-Jailbreak with Reinstall Cydia activated in unc0ver."
        erase_tmp
        pause
        start_menu
    }
    el() {
        check_connection $REPO_EL
        echo "Downloading Cydia from $CYDIADL_EL..."
        curl -o ./cydia.deb $CYDIADL_EL
        echo "Attempting to install Cydia..."
        echo "Running dpkg..."
        dpkg -i ./cydia.deb
        echo "Running uicache... (this may take some time)"
        uicache
        echo "Cleaning up..."
        rm -f ./cydia.deb
        cd /
        echo "Completed installation process for Cydia. You may want to run ldrestart after this script has concluded."
        erase_tmp
        pause
        start_menu
    }

    which_cydia() {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -e "1. apt.bingner.com (Unc0ver)"
    echo -e "2. electrarepo64.coolstar.org (Electra)"
    echo "0. Exit"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    }
    read_cydia_options() {
        local choice
        read -p "Where would you like to download Cydia from? [ 0 - 2 ] " choice
        case $choice in
            1) u0 ;;
            2) el ;;
            0) start_menu;;
            *) echo -e "${RED}Invalid Option...${STD}" && sleep 2
        esac
    }
    which_cydia
    read_cydia_options
}
run_diatrus_cydia_patch() {
    check_if_root
    echo "Patching Cydia and Sileo..."
    killall Cydia
    killall SIleo
                ## From Diatrus Sileo Installer for unc0ver 

                echo '<?xml version="1.0" encoding="UTF-8"?>
                <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                <plist version="1.0">
                <dict>
                    <key>platform-application</key>
                    <true/>
                    <key>com.apple.private.skip-library-validation</key>
                    <true/>
                    <key>com.apple.private.security.no-container</key>
                    <true/>
                </dict>
                </plist>' >> ./ent.xml
                sed -i "s/sources\.list\.d/sources\.cydiad/g" /Applications/Cydia.app/Cydia
                mkdir -p /etc/apt/sources.cydiad/
                if ! [ -s /etc/apt/sources.cydiad/cydia.list ]; then
                    ln -s /var/mobile/Library/Caches/com.saurik.Cydia/sources.list /etc/apt/sources.cydiad/cydia.list
                fi
                rm -f /private/etc/apt/sources.list.d/cydia.list
                chown 501:501 /Applications/Cydia.app/Cydia
                ldid -S./ent.xml /Applications/Cydia.app/Cydia
                chown 0:0 /Applications/Cydia.app/Cydia

                echo "Patched!" && sleep 2
}

echo -e "This utility breaks Cydia.app after a restore for some. ${RED}Reinstalling Cydia${STD} seems to fix this issue. Your tweaks and sources will not be erased."
        read -p "Would you like to reinstall Cydia? [Y/N] " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
                reinstall_cydia
        else
        echo "You can run ${RED}Reinstall Cydia${STD} from the Patches Menu"
        pause
        start_menu
        fi

echo -e "After reinstalling Cydia, you may need to run a patch that fixes duplicate sources. This may only be needed if you are using both Sileo and Cydia on unc0ver. Your tweaks and sources will not be erased."
        read -p "Would you like to patch Cydia? [Y/N] " -n 1 -r

        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
                run_diatrus_cydia_patch
        else
        echo -e "You can run ${RED}Patch Cydia${STD} from the Patches Menu"
        pause
        start_menu
        fi

echo "Updating sources..."
apt-get update

echo "Done!"

exit 0;


