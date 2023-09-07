#!/bin/bash

# Check if there are updates
if [ ! -e /var/lib/ossim/backup ]
then
  exit
fi
##########
# Backup Server Host/IP
host=""
# Backup Server Host/IP port if not apply for SSH or is modified
port=""
# Backup Server User
user=""
# Checking if the programm was executed previously and create some envs
if [ ! -e /var/log/backup_script_errors ]
then
  mkdir /var/log/backup_script_errors
fi
folderror=/var/log/backup_script_errors
# Compressing
tar -cJf /tmp/$HOSTNAME_$(date +%F)_backup.tar.xz /usr/lib/ossim/backup/*setup* 2>$folderror/$(date +%F)_compression_error.log
#
rsync /tmp/*backup*$xz $user@$host:/path_to_remote_backup_folder 2>$folderror/$(date +%F)_rsync_error.log


