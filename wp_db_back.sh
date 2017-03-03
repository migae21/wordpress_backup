#!/bin/sh

unset DEBUG
#Uncomment the following line to get debuging ouput
#DEBUG="TRUE"

SCRIPTPATH=`dirname "$0"`

PATH=/usr/sbin:/sbin:/bin:/usr/bin
 
DB_USER="wordpress_db_user"
DB_PASS="wordpress_dp_pass"
DB_HOST="localhost"
 
SUB="$(date +"%Y-%m-%d")"
DEST="/srv/backup/wordpress"

MDB="$DEST/db/$SUB"
TARDIR="$DEST/db"
TARFILE="database.tar"
NOW="$(date +"%Y-%m-%d_%H-%M-%S")"
TARFILE=$TARFILE$NOW 

debugecho ()
{ if [ ! -z "$DEBUG" ]; then echo "$*"; fi }
 
if [ ! -d $MDB ]
then
    mkdir -p $MDB ; debugecho "Directory $MDB created." ||  debugecho "Error: Failed to create $MDB directory."
else
    debugecho "Error: $MDB directory exits!"
fi

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


tar cf $TARDIR/$TARFILE $MDB


 
$SCRIPTPATH/rotate_backups -d=$DEST -s=$TARDIR -f=$TARFILE
debugecho "rotate Backup invoked"
rm -rf $MDB
