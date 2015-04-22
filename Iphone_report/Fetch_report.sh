#!/bin/bash

## script will check for  the latest report on 10.23.80.67 
## and will send it via email to audience

location="/data/offshore_support/Iphone_report"

Check_latest=`ssh root@10.23.80.67 "ls -lrth /data1/script_output/iPhone_usage/2015/*/*/iPhone_usage_* " |awk -F " " '{print $NF}' |tail -1`

last_fetch=`cat $location/last_fetch.log`


if [ $last_fetch -ne Check_latest ]

	then
		"scp and do mail"
		echo $Check_latest > $location/last_fetch.log
else
	exit;
fi

