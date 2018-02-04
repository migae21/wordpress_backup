#!/bin/sh

unset DEBUG
#Uncomment the following line to get debuging ouput
#DEBUG="TRUE"

SCRIPTPATH=`dirname "$0"`
PATH=/usr/sbin:/sbin:/bin:/usr/bin
 
DB_USER="replace with db-user"
DB_PASS="replace with db-passwd"
DB_HOST="replace with sql-host, normaly localhost"
DATABASE="database name"
#unset DATABASE      #uncomment to backup all th user databases
DEST="/srv/backup/wordpress"

if [ -r $SCRIPTPATH/.wp_config ]; then
  echo "Reading user config...." >&2
  . $SCRIPTPATH/.wp_config
fi

NOW=$(date +"%Y-%m-%d")

MDB="$DEST/db/$NOW"
TARDIR="$DEST/db"
TARFILE="wordpress-db-${NOW}.tar" 

debugecho ()
{ if [ ! -z "$DEBUG" ]; then echo "$*"; fi }
 
if [ ! -d $MDB ]
then
    mkdir -p $MDB ; debugecho "Directory $MDB created." ||  debugecho "Error: Failed to create $MDB directory."
else
    debugecho "Error: $MDB directory exits!"
fi

FILE=""
 

if [ -z "$DATABASE" ]; then
    DBS=$DATABASE
else
    DBS="$(mysql -u $DB_USER -h $DB_HOST -p$DB_PASS -Bse 'show databases')"
fi
 
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
