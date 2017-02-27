#!/bin/bash
 
PATH=/usr/sbin:/sbin:/bin:/usr/bin
 
user="wordpress_db_user"
pass="wordpress_dp_pass"
host="localhost"
 
sub="$(date +"%Y-%m-%d")"
dest="/srv/wordpress/backup"
mdb="$dest/db/$sub"
 
if [ ! -d $mdb ]
then
    mkdir -p $mdb ; echo "Directory $mdb created." ||  echo "Error: Failed to create $mdb directory."
else
    echo "Error: $mdb directory exits!"
fi
 
now="$(date +"%Y-%m-%d_%H-%M-%S")"
 
file=""
 
dbs="$(mysql -u $user -h $host -p$pass -Bse 'show databases')"
 
for db in $dbs
do
    file="$mdb/$db.$now.sql.gz"
    mysqldump --single-transaction -u $user -h $host -p$pass --complete-insert $db | gzip -9 > $file
    echo "Backup $file.....DONE"
done
 
find $dest/db/ -maxdepth 1 -type d -mtime +6 -exec echo "Removing Directory => {}" \; -exec rm -rf "{}" \;
