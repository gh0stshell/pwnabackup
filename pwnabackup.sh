!/usr/bin/env bash
#
# Version 1.4b
#
# Modded version of original backup
# script that does not requite root
# to be setup/enabled and puts the
# output zip file in the pi home
# folder and all copied files
# under /home/pi/pwnabackup
#
# Backup: sudo ./pwnabackup.sh
#
# Restore: sudo tar -xvf /home/pi/nameOFfile.tar.gz -C/
#

UNIT_HOSTNAME=$(cat /etc/hostname)

# output backup zip file
OUTPUT=$(pwnagotchi-backup.tar.gz)

# temp folder
BACKUP_LOCATION=/home/pi/pwnabackup

# what to backup
FILES_TO_BACKUP=(
  /root/brain.nn
  /root/brain.json
  /root/.api-report.json
  /root/handshakes
  /etc/pwnagotchi/
  /etc/hostname
  /etc/hosts
  /etc/motd
  /var/log/pwnagotchi.log
)

echo "[+] backing up $UNIT_HOSTNAME to $OUTPUT ..."

echo "[!] Remove existing backup if exists first!"

# Deleting old backups before creating new backup archive
rm -rf "$BACKUP_LOCATION"

# Create folders & Copy files to backup location
for file in "${FILES_TO_BACKUP[@]}"; do
  dir=$(dirname $file)
  echo "  $file -> $BACKUP_LOCATION$dir/"
  mkdir -p "$BACKUP_LOCATION/$dir"
  sudo cp -R $file "$BACKUP_LOCATION$dir/"
done

echo "[+] Copy completed!\n"
echo "[?] Check above for any errors\n"
echo "[+] Now archiving files copied\n"

# Archive copied files
ZIPFILE="$PWD/$OUTPUT"
pushd $PWD
cd "$BACKUP_LOCATION"
tar -cvzf "$ZIPFILE" .
popd

echo "[+] Completing final task, remove copied files"

#Removing copied files but leaving archive
rm -rf "$BACKUP_LOCATION/root"
rm -rf "$BACKUP_LOCATION/etc"
rm -rf "$BACKUP_LOCATION/var"
