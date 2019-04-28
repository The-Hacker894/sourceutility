#!/bin/sh


clear
VER="1.0~7"
echo "sourceutility restore_cydia v$VER"

DIRECTORY=`dirname $0`

SOURCELISTS="/private/etc/apt/sources.list.d" # Will need to copy everything from this directory to complete backup
SOURCELISTSBACKUPDIR="./sourcelists"

SOURCELISTSCYDIAD="/private/etc/apt/sources.cydiad" 
SOURCELISTSCYDIADBACKUPDIR="./cydiad"

CYDIASOURCESD="/private/etc/apt/cydiasources.d"
CYDIASOURCESDBACKUPDIR="./cydiasourcesd"

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
if [ -d /electra ]; then
        echo "${RED}ELECTRA DETECTED${STD}"
        echo "${RED}WARNING:${STD} During my testing on iOS 11 (Electra1141), this tool broke Cydia and I was unable to fix it. Restoring RootFS may not even fix Cydia."
        echo "Unc0ver and Unc0ver Dark users are fine, but Electra11 users should not try restoring Cydia Sources..."
        read -p "Are you sure you still want to continue?"
        echo
        if ! [[ $REPLY =~ ^[Yy]$ ]]; then
            exit 1;
        fi
fi
check_for_cydia_deb() {
    if [ ! -f ./cydia.deb ]; then
        echo "Cydia could not be downloaded... You can attempt to reinstall Cydia through an alternative method."
        exit 1;
    fi
}
check_connection() {
        URL=$1
        echo $URL

        ex() {
            echo "Could not connect to $URL..."
            read -p "Press [Enter] to continue..." fackEnterKey 
        }
        cont() {
            echo "Connection to $URL returned no errors!"
        }
            echo "Checking ability to connect to '$URL'..."
            
            case "$(curl --insecure-s --max-time 2 -I $URL | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
        [23]) cont ;;
        5) ex ;;
        *) ex;;
            esac
    
}
# Checking for Cydia installation
echo "Checking for Cydia installation..."
dpkg-query -W -f='${Status}\n' "cydia" | grep 'install ok' &> /dev/null
        if [ ! $? == 0 ]; then
                read -p "Cydia is not installed. Do you still wish to continue? [Y/N]" -n 1 -r
                echo
                if ! [[ $REPLY =~ ^[Yy]$ ]]; then
                exit 1;
                fi
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

if [ -d $SOURCELISTSCYDIAD ]; then
    if [ "$(ls -A $SOURCELISTSCYDIADBACKUPDIR)" ]; then
    ## Not Empty
    echo "Copying sources.cydiad Backups to $SOURCELISTSCYDIAD"
    cp -afv "$SOURCELISTSCYDIADBACKUPDIR/." $SOURCELISTSCYDIAD
    else
    ## Empty
    echo "$SOURCELISTSCYDIADBACKUPDIR is either empty or does not exist. Continuing with restore!"
    fi
fi

if [ -d $CYDIASOURCESD ]; then
    if [ "$(ls -A $CYDIASOURCESDBACKUPDIR)" ]; then
    ## Not Empty
    echo "Copying sources.cydiad Backups to $CYDIASOURCESD"
    cp -afv "$CYDIASOURCESDBACKUPDIR/." $CYDIASOURCESD
    else
        ## Empty
        echo "$CYDIASOURCESDBACKUPDIR is either empty or does not exist. Continuing with restore..."
    fi
else
echo "$CYDIASOURCESD is either empty or does not exist. Continuing with restore..."
fi

echo "Finished restoring Cydia Sources!"
pause

erase_tmp() {
        echo "Cleaning up..."
        rm -rf tmp/
}
reinstall_cydia() {
    
    mkdir tmp/
    cd tmp/
    check_if_root
    killall Cydia
    killall Sileo
    echo "Checking for tmp directory..."
    
    REPO_U0="https://apt.bingner.com"
    REPO_EL="https://electrarepo64.coolstar.org"
    
    u0() {
        check_connection $REPO_U0
        echo "Downloading Electra Packages..."
        cur --insecure -o "./$U0TMP" "$REPO_U0/Packages" && sleep 1

        touch "./$CYDIATMP"

        awk '/^Package: cydia$/ {s=NR;next} s && NR<=s+15' "./$U0TMP" &> $CYDIATMP
        CYDIAURL=$REPO_U0/$(awk -F'Filename:' '{print $2}' $CYDIATMP)
        CYDIAURL_CONDENSED="$(echo -e "${CYDIAURL}" | tr -d '[:space:]')"
        rm -f "./$CYDIATMP"
        
        echo "Downloading latest version of Sileo..."
        cur  --silent --insecure -o ./cydia.deb $CYDIAURL_CONDENSED

        echo "Installing..."
        dpkg -i ./cydia.deb

        echo "Running uicache"
        uicache
        echo "Cleaning up..." 
        rm -f ./cydia.deb
        cd /
        echo "Completed installation process for Cydia. You may want to run ldrestart after this script has concluded. "
        pause
        start_menu
    }
    el() {
        check_connection $REPO_EL
        echo "Downloading Electra Packages..."
        cur --insecure -o "./$ELECTRATMP" "$REPO_EL/Packages" && sleep 1

        touch "./$CYDIATMP"

        awk '/^Package: cydia$/ {s=NR;next} s && NR<=s+15' "./$ELECTRATMP" &> $CYDIATMP
        CYDIAURL=$REPO_EL/$(awk -F'Filename:' '{print $2}' $CYDIATMP)
        CYDIAURL_CONDENSED="$(echo -e "${CYDIAURL}" | tr -d '[:space:]')"
        rm -f "./$CYDIATMP"
        
        echo "Downloading latest version of Sileo..."
        cur  --silent --insecure -o ./cydia.deb $CYDIAURL_CONDENSED

        echo "Installing..."
        dpkg -i ./cydia.deb

        echo "Running uicache"
        uicache
        echo "Cleaning up..." 
        rm -f ./cydia.deb
        cd /
        echo "Completed installation process for Cydia. You may want to run ldrestart after this script has concluded. "
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

echo -e "After reinstalling Cydia, you may need to run a patch that fixes duplicate sources. This may only be needed if you are using both Sileo and Cydia on unc0ver or use unc0ver dark. Your tweaks and sources will not be erased."
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


