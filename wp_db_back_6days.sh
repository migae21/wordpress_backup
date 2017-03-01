#!/bin/sh

unset DEBUG
#Uncomment the following line to get debuging ouput
#DEBUG="TRUE"

PATH=/usr/sbin:/sbin:/bin:/usr/bin
 
DB_USER="wordpress_db_user"
DB_PASS="wordpress_dp_pass"
DB_HOST="localhost"
 
SUB="$(date +"%Y-%m-%d")"
DEST="/srv/backup/wordpress"

MDB="$DEST/db6/$SUB"
DAYS=6
function debugecho()
{ if [ ! -z "$DEBUG" ]; then echo "$*"; fi }
 
if [ ! -d $MDB ]
then
    mkdir -p $MDB ; debugecho "Directory $MDB created." ||  debugecho "Error: Failed to create $MDB directory."
else
    debugecho "Error: $MDB directory exits!"
fi
 
NOW="$(date +"%Y-%m-%d_%H-%M-%S")"
 
FILE=""
 
DBS="$(mysql -u $DB_USER -h $DB_HOST -p$DB_PASS -Bse 'show databases')"
 
for DB in $DBS
do
    FILE="$MDB/$DB.$NOW.sql.gz"
    mysqldump --single-transaction -u $DB_USER -h $DB_HOST -p$DB_PASS --complete-insert $DB | gzip -9 > $FILE
    debugecho "Backup $FILE.....DONE"
done
 
find $DEST/db6/ -maxdepth 1 -type d -mtime +$DAYS -exec echo "Removing Directory => {}" \; -exec rm -rf "{}" \;

