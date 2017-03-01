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

MDB="$DEST/db/$SUB"
TARDIR="$DEST/db"
TARFILE="database.tar"
 
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
    FILE="$MDB/$DB.$NOW.sql.gz"
    mysqldump --single-transaction -u $DB_USER -h $DB_HOST -p$DB_PASS --complete-insert $DB | gzip -9 > $FILE
    debugecho "Backup $FILE.....DONE"
done

tar cf $TARDIR/$TARFILE $MDB


 
./rotate_backups -d=$DEST -s=$TARDIR -f=$TARFILE
debugecho "rotate Backup invoked"
rm -rf $MDB
