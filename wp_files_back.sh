#!/bin/sh
unset DEBUG
#Uncomment the following line to get debuging ouput
#DEBUG="TRUE"

SCRIPTPATH=`dirname "$0"`/
#det the path to your install
BACKUP_FILES="/usr/share/wordpress"
#Backupdirectory
DEST="/srv/backup/wordpress"
#temp inside the Backupdirectory
TEMP=$DEST"/tmp/"

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
FILENAME="WP_FILES$HOST-$DAY.tgz"
 
tar czf $TEMP$FILENAME $BACKUP_FILES
$SCRIPTPATH/rotate_backups -d=$DEST -s=$TEMP -f=$FILENAME
debugecho "rotate Backup invoked"
rm -f $TEMP


