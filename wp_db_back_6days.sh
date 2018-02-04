#!/bin/sh

unset DEBUG
#Uncomment the following line to get debuging ouput
#DEBUG="TRUE"

PATH=/usr/sbin:/sbin:/bin:/usr/bin
 
DB_USER="replace with db-user"
DB_PASS="replace with db-passwd"
DB_HOST="replace with sql-host, normaly localhost"
DATABASE="replace with database name"
#unset DATABASE      #uncomment to backup all th user databases
DEST="replace with location to save the backup"

if [ -r $SCRIPTPATH/.wp_config ]; then
  echo "Reading user config...." >&2
  . $SCRIPTPATH/.wp_config
fi

 
SUB="$(date +"%Y-%m-%d")"
DEST="/srv/backup/wordpress"

MDB="$DEST/db6/$SUB"
DAYS=6

debugecho ()
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
    if [ "$DB" != "information_schema" ] && [ "$DB" != "performance_schema" ] && [ "$DB" != "mysql" ] && [ "$DB" != _* ] ; then
        debugecho "Dumping database: $db"
        FILE="$MDB/$DB.$NOW.sql.gz"
        mysqldump --single-transaction -u $DB_USER -h $DB_HOST -p$DB_PASS --complete-insert --skip-lock-tables $DB | gzip -9 > $FILE
        debugecho "Backup $FILE.....DONE"
    fi
done
 
find $DEST/db6/ -maxdepth 1 -type d -mtime +$DAYS -exec echo "Removing Directory => {}" \; -exec rm -rf "{}" \;

