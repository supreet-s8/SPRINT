#!/bin/sh

#This script will check collector writing on backup or HDFS.
#Script will run every 30 minute.


HDFS=`ssh -q root@10.23.80.11 "HADOOP_CONF_DIR=/data/configs/backup_hadoop_conf/  /opt/hadoop/bin/hadoop dfs -dus /data" 2>/dev/null|awk '{print $NF}'`

if [[ "$HDFS" -gt 2000000000 ]]
        then
                echo "Local $HDFS  is greater than 25Gb"
                echo "Terminating Collector..."
                ssh -q root@10.23.80.11 "/opt/tms/bin/cli -m config -t 'pm process collector terminate'"
                sleep 30
                Stats=`ssh -q root@10.23.80.11 "/opt/tms/bin/cli -m config -t 'sh pm process collector' |grep 'status:'"`
                echo "$Stats"
                echo "Collector has been Terminate : $Stats"|mail -s "Collector Writing On Backup" -r Sprint_production.monitoring@guavus.com    noc.support@guavus.com samuel.joseph@guavus.com jatinder.singh@guavus.com  eric.darby@guavus.com robert.phillips@guavus.com mohsin.ali@guavus.com 
	
fi
