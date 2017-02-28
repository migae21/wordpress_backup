#!/bin/sh
 
BACKUP_FILES="/usr/share/wordpress"
DEST="/srv/wordpress/backup"
TEMP="/tmp/
 
DAY=$(date +%A)
HOST=$(hostname -s)
FILENAME="WP_FILES$HOST-$DAY.tgz"
 
tar czf $TEMP$FILENAME $BACKUP_FILES
rotate_backups "-d $DEST" "-s $TEMP" "-f $FILENAME"

