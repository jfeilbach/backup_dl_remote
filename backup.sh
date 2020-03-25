#!/bin/bash

SECONDS=0
LOCAL_PATH='/Volumes'
DIR='vol2'

NC='\e[0m'
WHITE='\e[1;37m'
YELLOW='\e[1;33m'
LIGHT_BLUE='\e[1;34m'
CYAN='\e[0;36m'
RED='\e[0;31m'

echo "Checking for root privelages..."
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

echo -e "${CYAN}You are now user:${NC} ${YELLOW}$(whoami)${NC}\n"

/usr/bin/osascript -e "try" -e "mount volume \"smb://jason@nas5.local/vol2/\"" -e "end try"
/usr/bin/osascript -e "try" -e "mount volume \"smb://jason@nas5.local/vol2/\"" -e "end try"

check_mount_exist () {
    if [[ -d "${LOCAL_PATH}/${DIR}" ]] ; then
        echo -e "Mount point ${WHITE}${LOCAL_PATH}/${DIR}${NC} exists. Proceeding...\n"
        else
        	echo -e "${RED}Mount point ${WHITE}${LOCAL_PATH}/${DIR}${NC}${RED} does not exist. Exiting.${NC}\n"
        	exit 1
    fi
}

rsync -avhz --stats --progress \
--exclude='$RECYCLE.BIN' \
--exclude='$Recycle.Bin' \
--exclude='.AppleDB' \
--exclude='.AppleDesktop' \
--exclude='.AppleDouble' \
--exclude='.com.apple.timemachine.supported' \
--exclude='.dbfseventsd' \
--exclude='.DocumentRevisions-V100*' \
--exclude='.DS_Store' \
--exclude='.fseventsd' \
--exclude='.PKInstallSandboxManager' \
--exclude='.Spotlight*' \
--exclude='.SymAV*' \
--exclude='.symSchedScanLockxz' \
--exclude='.TemporaryItems' \
--exclude='.Trash*' \
--exclude='.vol' \
--exclude='.VolumeIcon.icns' \
--exclude='Desktop DB' \
--exclude='Desktop DF' \
--exclude='hiberfil.sys' \
--exclude='lost+found' \
--exclude='Network Trash Folder' \
--exclude='pagefile.sys' \
--exclude='Recycled' \
--exclude='RECYCLER' \
--exclude='System Volume Information' \
--exclude='Temporary Items' \
--exclude='Thumbs.db' \
--exclude='.HFS+ Private Directory Data\#015' \
--exclude='.PKInstallSandboxManager-SystemSoftware' \
/Volumes/Raid\ 0/Torrent\ Downloads/ /Volumes/vol2/tinkey_torrents/

exit 0
