A sample Wordpress Backup (files and database)

#####USAGE

######Get the code
```
mkdir -p /root/scripts
git clone https://github.com/migae21/wordpress_backup
```
######sample crontab lines
```
0 4 * * * /root/scripts/wordpress_backup/wp_db_back.sh > /dev/null 2>&1
#only if you need to backup the wordpress files, config and plugins
30 3 * * * /root/scripts/wordpress_backup/wp_files_back.sh > /dev/null 2>&1
#(optional a db backup every 10 minutes with a history of 6 days (makes a lot of data))
*/30 * * * * /root/scripts/wordpress_backup/wp_db_back_6days.sh > /dev/null 2>&1 
```
######Where are the backups?

```
The backups are located under /srv/backup/wordpress
change DEST="to/your/backup/path"
in the following scripts:
wp_db_back.sh 
wp_files_back.sh 
wp_db_back_6days.sh 
```
######minimal configure
set 
```
DB_USER="wordpress_db_user"  # (no extra privileges needed)
DB_PASS="wordpress_dp_pass"
in the following scripts
wp_db_back.sh 
wp_db_back_6days.sh 
```
set 
```
BACKUP_FILES="/PATH/to/WORDPRESS"
in wp_files_back.sh

Ore Use th .wp_config file an place.it in the same directory as the scripts 
DB_USER="replace with db-user"
DB_PASS="replace with db-passwd"
DB_HOST="replace with sql-host, normaly localhost"
DATABASE="replace with database name"
#unset DATABASE      #uncomment to backup all th user databases
DEST="replace with location to save the backup"
TEMP="$DEST/tmp/"



```

