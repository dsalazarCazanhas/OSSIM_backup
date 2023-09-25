#!/bin/bash
if [ ! -d /var/alienvault/backup ]
then
	exit
fi
backup_user='bavapi'
backup_ip="192.168.65.178"
path2backup="~/ossim_backup"
if [ ! -d /var/alienvault/backup_script_errors  ]
then
	mkdir /var/alienvault/backup_script_errors
fi
rm /tmp/*backup*.xz 2>/dev/null
tar -cJf /tmp/$HOSTNAME_$(date +%F)_backup.tar.xz /var/alienvault/backup/*configuration*$'gz' 2> /var/alienvault/backup_script_errors/$(date +%F)_error.log
rsync /tmp/*backup*$'xz' ${backup_user}@${backup_ip}:${path2backup}
echo "done!!"
