#!/bin/bash
# version 1.0
# 4 April 2020

SECONDS=0

stty sane

local_path='/Volumes'
src='/Volumes/Raid 0/Torrent Downloads/'
dest='/Volumes/vol2/tinkey_torrents/'
dir1='vol1'
dir2='vol2'
timestamp='/Users/jason/backup.date'

# Mac bash colors
NC='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'

get_last () {
    echo ""
    time_val=$(cat ${timestamp})
    echo -e "${WHITE}Last backup was ${NC}${CYAN}${time_val}${NC}\n"
}

set_last () {
    rm ${timestamp}
    $(date > ${timestamp})
    chown jason:staff ${timestamp}
}

displaytime () {
   local T=$SECONDS
   local D=$((T/60/60/24))
   local H=$((T/60/60%24))
   local M=$((T/60%60))
   local S=$((T%60))
   [[ $D > 0 ]] && printf '%d days ' $D
   [[ $H > 0 ]] && printf '%d hours ' $H
   [[ $M > 0 ]] && printf '%d minutes ' $M
   [[ $D > 0 || $H > 0 || $M > 0 ]] && printf 'and '
   printf '%d seconds\n' $S
}

check_mount () {
    if mount | grep "on $1" > /dev/null; then
        echo -e "${GREEN}Success:${NC} ${WHITE}${1} is mounted.${NC}\n"
    else
        echo -e "#{RED}Warning. ${1} is NOT mounted.${NC}${YELLOW} Mounting...${NC}\n"
        /usr/bin/osascript -e "try" -e "mount volume \"smb://jason@nas5.local/vol1/\"" -e "end try"
        retVal=$?
        if [ $retVal -ne 0 ]; then
            echo -e "${RED}Error: Command failed. Exiting.${NC}\n"
            exit $retVal
        fi
    fi
}

get_last

echo -e "Checking for root priveleges...\n"
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

echo -e "${CYAN}You are now the user:${NC} ${YELLOW}$(whoami)${NC}\n"

echo -e "Checking for mounted volumes...\n"

local_mnt1="${local_path}/${dir1}"
check_mount ${local_mnt1}

local_mnt2="${local_path}/${dir2}"
check_mount ${local_mnt2}

echo -e "${YELLOW}Starting backup...${NC}"

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
"${src}" "${dest}"

set_last

echo ""
echo -e "${CYAN}Finished.${NC}${GREEN} ${0}${NC}${CYAN} Completed in ${NC}${WHITE}$(displaytime)${NC}.\n"

exit 0
