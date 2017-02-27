#!/bin/sh
 
backup_files="/usr/share/wordpress"
 
dest="/srv/wordpress/backup"
 
day=$(date +%A)
host=$(hostname -s)
archive_file="$host-$day.tgz"
 
tar czf $dest/$archive_file $backup_files
