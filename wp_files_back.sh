#!/bin/sh
unset DEBUG
#Uncomment the following line to get debuging ouput
#DEBUG="TRUE"
PATH=/usr/sbin:/sbin:/bin:/usr/bin
SCRIPTPATH=`dirname "$0"` 
#det the path to your install
BACKUP_FILES="/usr/share/wordpress"
#Backupdirectory
DEST="/srv/backup/wordpress"
#temp inside the Backupdirectory
TEMP="$DEST/tmp/"

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


debugecho ()
{ if [ ! -z "$DEBUG" ]; then echo "$*"; fi }

if [ ! -d $TEMP ]
then
    mkdir -p $TEMP ; debugecho "Directory $TEMP created." ||  debugecho "Error: Failed to create $TEMP directory."
else
    debugecho "$TEMP directory exits!"
fi
 
DAY=$(date +%A)
HOST=$(hostname -s)
FILENAME="WP_FILES-$HOST-$DAY.tgz"
 
tar czf $TEMP$FILENAME $BACKUP_FILES
$SCRIPTPATH/rotate_backups -d=$DEST -s=$TEMP -f=$FILENAME
debugecho "rotate Backup invoked"
rm -rf $TEMP


