# sourceutility
The all-in-one utility for managing your already added Cydia and Sileo sources.  
Formerly [sourcebackup](https://github.com/The-Hacker894/sourcebackup)  
  
![Img](https://skylarmccauley.xyz/hacked-repo/depic/xyz.skylarmccauley.sourceutility/screenshots/menu.png)  
  

## What Each Option Does  
  
### Start Menu  
Opens Start Menu (for `sourceutility`)  
  
### Backup Cydia and/or Sileo Sources  
Use this option if you would like to backup your Cydia and Sileo sources. As of v0.5, this will only work if you have either just Cydia installed or Cydia and Sileo installed. It will not work if only Sileo is installed.  
  
### Restore Cydia and Sileo Sources  
Use this option if you would like to restore a backup created by `sourceutility`. If you are restore Cydia sources, you will need to reinstall Cydia afterwards and possibly run the Cydia Patch if you have Sileo installed with unc0ver.  
  
### Delete Cydia/Sileo Source Backups  
Use this option if you would like to delete all of your backups created by `sourceutility`.  
  
### Convert Legacy Backups  
Convert backups from version `<=0.3-2`to be compatible with `sourceutility >=0.4`. Keep in mind backups from `<=0.3-2` may not restore correctly even if converted to be compatible with newer versions of `sourceutility`.  
  
### Sync Cydia Sources to Sileo  
This feature is not available at this time. It is planned to sync your Cydia sources to Sileo.  
  
### Sync Sileo Sources to Cydia  
This feature is not available at this time. It is planned to sync your Sileo sources to Cydia.  
  
### Utilies Menu  
Opens Utilities Menu  
  
### ldrestart  
Runs ldrestart (pretty much Reload System Daemons in unc0ver).  
  
### uicache  
Runs uicache. This allows apps installed via a `.deb` file or Cydia to show up on the HS.  
  
### Reboot  
Runs reboot.  
  
### Purge .DS_STORE files  
Purges `.DS_STORE` files. There was an issue with some versions of `sourceutility` having `.DS_STORE` files packaged in. This issue should be fixed, but should it crop up again, this option will fix the issue.  
  
### Purge Cydia & Sileo Lists/Sources  
Purges Cydia and Sileo Source Lists. Probably not the option you want to choose.  
  
### apt-get update  
Runs apt-get update. Will update local source lists.  
  
### Patches Menu  
Opens Patches Menu  
  
### Patch Cydia  
Patches Cydia after restoring source lists. This issue is prevalent with users that have Sileo installed alongside Cydia on unc0ver.  
  
### Reinstall Cydia  
Downloads Cydia from apt.bingner.com and installs it.  
  
### Kill Springboard  
Runs killall springboard.  
  
### Kill Cydia  
Runs killall Cydia.  
  
### Kill Sileo  
Runs kilall Sileo.  
  