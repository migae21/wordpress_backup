A sample Wordpress Backup (files and database)

#####USAGE

######Get the code
/*
mkdir -p /root/scripts
git clone https://github.com/migae21/wordpress_backup
*/
#######sample crontab lines
/*
0 4 * * * /root/scripts/wordpress_backup/wp_db_back.sh > /dev/null 2>&1
30 3 * * * /root/scripts/wp_files_back.sh > /dev/null 2>&1
#(optional a db backup every 10 minutes with a history of 6 days)
*/10 * * * * /root/scripts/wordpress_backup/wp_db_back_6days.sh > /dev/null 2>&1
*/
