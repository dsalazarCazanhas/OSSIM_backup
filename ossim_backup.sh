#!/bin/sh

# Check for backup user
if [ ! cat /etc/passwd | cut -d ':' -f 1=='ubackup' ]
then
	useradd ubackcup
fi

# Check if there are backups
if [ ! -e /var/alienvault/backup ]
then
	exit
fi
# Checking if the script was executed previously
if [ -e /var/alienvault/backup_script_errors ]
then
	compress
else
	mkdir /var/alienvault/backup_script_errors
	compress
fi

# Vars
folderror=/var/alienvault/backup_script_errors

function compress
{
 tar -cJf /tmp/$HOSTNAME_$(date +%F)_backup.tar.xz /var/alienvault/backup/*configuration*$'gz' 2>$folderror/$(date +%F)_error.log
}
# Rsync
function saveit
{
if[ -e /root/.ssh ]
then
	backup_user="dsalazar"
	backup_ip="192.168.65.178"
	path_to_backup="~/ossim_backup"
	rsync /tmp/*backup*$'xz' $backup_user@$backup_ip:$path_to_backup
else
	ssh-keygen -t rsa -C "OSSIM backup"
	ssh-copy-id user@hostip
fi
}
# Execution
compress
saveit