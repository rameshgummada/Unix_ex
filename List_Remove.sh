# Delete the logs older than 45 days  (List and Remove)
# Declare variables 
CONFIGFILE="/opt/support/scripts/configFile" 
HOURDATE=`date '+%Y%m%d%H%M'` 
CLEANDIR="/opt/netprobe/log" 
DELETELOG="/var/tmp/cleanup_$HOURDATE.log" 
if [ ! -f $CONFIGFILE ]; then 
        echo "Configuration File not found under $CONFIGFILE" 2>&1 
  exit 1 
fi 
for read_line in `cat $CONFIGFILE` 
do 
         log_name=`echo $read_line` 
         delete_logs $log_name 
done 
# | Sub Procedure to list the files & deletes them 
delete_logs() 
{ 
   log_name=$1 
    
 echo "Listing files to remove..." >> $DELETELOG 2>&1 
 /usr/bin/find $CLEANDIR type -f -name "$log_name*.*" -mtime +45 -exec ls -ltr {} \; >> $DELETELOG 2>&1 
 echo "Removing files --> $HOURDATE" >> $DELETELOG 2>&1 
 /usr/bin/find $CLEANDIR type -f -name "$log_name*.*" -mtime +45 -exec rm {} \; >> $DELETELOG 2>&1 
}

Get Outlook for iOS
