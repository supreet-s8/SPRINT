#!/bin/sh

#  Storage_health.sh
#  
#
#  Created by Jatinder Singh on 3/16/15.
#
## TWO FILES NEED TO CREATED UNDER MENTIONED PATH
## "host.txt" --------- with entries of hosts one per line on which commands need to be run.
## "commands.txt" ----- with number of commands one per line.

#loc=/offshore_support/storage_health
loc=/var/home/root

echo " CALLING SCRIPT FOR CHECKING STORAGE HEALTH "
echo " "

$loc/testing_expect.sh  >$loc/health.log


cat $loc/health.log|while read line; do  echo $line |grep -iE "Controller ID|IP Address|DISKS:|VDISK:"; done |awk '!a[$0]++' > $loc/out.txt


cat $loc/health.log|while read line; do  echo $line |grep -iE "FAILED$|NOT OK|NOT OPERATIONAL"; done

if [ $? -eq 1 ]

    then
 	echo -e "ALL THREE STORAGES STATUSES ARE : OK \n\n `cat $loc/out.txt`"
        #echo "ssh -q root@10.23.80.24 "echo -e 'ALL THREE STORAGES STATUSES ARE : OK \n\n `cat $loc/out.txt`' | mail -s 'Storage health checkUP' -r sprint.production.monitoring@guavus.com jatinder.singh@guavus.com""

else
	echo -e "ALL THREE STORAGES STATUSES ARE :NOT OK \n\n `cat $loc/out.txt`"
	#echo "ssh -q root@10.23.80.24 "echo '`ssh -q root@10.23.80.4 "cat $loc/health.log;cat $loc/out.txt"' | mail -s 'Storage health checkUP' -r sprint.production.monitoring@guavus.com jatinder.singh@guavus.com""
fi
