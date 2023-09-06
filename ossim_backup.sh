#!/bin/sh

# Checking if the programm was executed previously
function first_check 
{
if [ -e /var/log/backup_script_errors ]
then
  go_on
else
mkdir /var/log/backup_script_errors
  go_on
fi
}
#
function go_on
{
  tar -cJf $folder/$HOSTNAME_$(date +%F)_backup.tar.xz /usr/lib/ossim/backup/*setup* 2>$folderror/$(date +%F)_error.log
}
#
mkdir /tmp/script_griffith
folder=/tmp/script_griffith
folderror=/var/log/backup_script_errors
