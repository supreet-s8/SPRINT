#!/bin/bash
ssh -q root@10.23.80.4 "/data/GDS/MonitoringScript/process_liveness/sprint_monitor.sh"

sleep 15

val=`ssh -q root@10.23.80.4 "if [ -e /data/GDS/MonitoringScript/process_liveness/log.txt ]
			then
					cat /data/GDS/MonitoringScript/process_liveness/log.txt
fi"`

if [[ "$val" ]] 
then

	echo "$val"| mail -s "Sprint Wireless Process Liveness" -r sprint.production.monitoring@guavus.com  noc.support@guavus.com samuel.joseph@guavus.com mohsin.ali@guavus.com gds-india@guavus.com eric.darby@guavus.com robert.phillips@guavus.com
fi



#ssh -q root@10.23.80.4 "if [ -e /data/GDS/MonitoringScript/process_liveness/log.txt ]; then cat /data/GDS/MonitoringScript/process_liveness/log.txt ;fi" > sprintlog.txt
#if [ -e temp.txt ]
#then
#	out=`diff sprintlog.txt temp.txt`
#	if  [ $? -ne 0 ]
#	then
#		cat sprintlog.txt > temp.txt
	#echo "$val" | mail -s "Sprint Wireless Process Liveness" -r sprint.production.monitoring@guavus.com gaurav.babbar@guavus.com jatinder.singh@guavus.com
	
#		mail -s "Sprint Wireless Process Liveness" -r sprint.production.monitoring@guavus.com gaurav.babbar@guavus.com jatinder.singh@guavus.com < sprintlog.txt
#	fi

#else
#	mail -s "Sprint Wireless Process Liveness" -r sprint.production.monitoring@guavus.com gaurav.babbar@guavus.com jatinder.singh@guavus.com < sprintlog.txt
#fi
