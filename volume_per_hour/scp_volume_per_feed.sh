#!/bin/sh


scp root@10.23.80.4:/data/offshore_support/`ssh root@10.23.80.4 "ls -lrth /data/offshore_support/"|grep final|tail -1|awk '{print $NF}'` /data/offshore_support/volume_per_hour/
file=`ls -lrth /data/offshore_support/volume_per_hour/ |grep final  |tail -1 |awk '{print $NF}'`

echo "PFA Report for Volume of files per hour for each adaptor" |mail -a /data/offshore_support/volume_per_hour/${file}  -s "Daily Volume per feeds" -r sprint.production.monitoring@guavus.com  jatinder.singh@guavus.com gaurav.babbar@guavus.com samuel.joseph@guavus.com 


sleep 5 

ls /data/offshore_support/volume_per_hour/ |grep final |xargs -I {} rm -f /data/offshore_support/volume_per_hour/{}
