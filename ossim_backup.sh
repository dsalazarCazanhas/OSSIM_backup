#!/bin/bash
errors_logs="/var/log/external_bck"

#gen_logs(){
if [ ! -d "$errors_logs" ]; then mkdir "$errors_logs"; fi
#}


copy_ssh(){
	local backup_user="ssh_user"
	local backup_ip="ssh_ip"
	local path2backup="/srv/home/ossim_backup/"
	local ssh_pub_key="$HOME/.ssh/id_rsa_pub"

	scp -i "$ssh_pub_key" /tmp/*backup*$'xz' "${backup_user}@${backup_ip}:${path2backup}"
}

compress(){
	tar -cvJf "/tmp/${HOSTNAME}_$(date +%F)_framw.tar.xz" "/var/alienvault/backup/configuration*$gz" 2> "$errors_logs/$(date +%F)_error.log"
	tar -cvJf "/tmp/${HOSTNAME}_$(date +%F)_siem.tar.xz" "/var/lib/ossim/backup/configuration*$gz" 2> "$errors_logs/$(date +%F)_error.log"
}

transfer_ssh() {
	local alienvault_backup="/var/alienvault/backup/"
	local ossim_backup="/var/lib/ossim/backup/"

#	if [ ! -d $alienvault_backup ]; then
#		echo "ossim_backup: $alienvault_backup: ENOENT No such file or directory" > /dev/stderr
#		exit 2
#	fi

  compress
	copy
	retry copy
}

transfer_nfs() {
	local alienvault_backup="/var/alienvault/backup/"
	local ossim_backup="/var/lib/ossim/backup/"

	if [ ! -d $alienvault_backup ]; then
		echo "ossim_backup: $alienvault_backup: ENOENT No such file or directory" > /dev/stderr
		exit 2
	
  mount -n ${host_backup}:${server_backup_folder} /mnt
	compress "$alienvault_backup"
	#compress "siem_backup" "$ossim_backup"
	copy
	retry copy
}

main() {
	local timestamp="$HOME/timestamp"
	local current_date=$(date +%F)

	gen_logs

	if [ ! -d "$timestamp" ]; then
		touch "$timestamp"
		echo "$current_date" > "$timestamp"
		transfer
		echo "done"
	elif cat "$timestamp" ! date; then
		:> "$timestamp"
		echo "$current_date" > "$timestamp"
		rm /tmp/*backup*.xz 2>/dev/null
		transfer
	else echo "no changes"
	fi

	exit 1
}

#main
#gen_logs
compress

#configurar ssh
#comprobacion de errores
#
#loop through a directory and pipe output
#for x in */ ; do date -r $x; done | sort -n
#array destructuring
#read -r a b c <<<$(echo 1 2 3) ; echo "$a|$b|$c"
#parse output into string
#var=($(./inner.sh))


#tar -cJf /tmp/$HOSTNAME_$(date +%F)_configuration_backup.tar.xz ${alienvault_backup}*configuration*$'gz' 2> /var/alienvault/backup_script_errors/$(date +%F)_error.log

#tar -cJf /tmp/$HOSTNAME_$(date +%F)_siem_backup.tar.xz ${ossim_backup}*configuration*$'gz' 2> /var/alienvault/backup_script_errors/$(date +%F)_error.log
