#!/bin/sh

now=`date +%Y-%m-%d`;

OUTPUT=`ssh -q root@10.23.80.70 "/opt/tms/bin/pmx subshell oozie show workflow KILLED jobs"| grep -vE 'grep|No' | awk '{print $2, $10, $11}'| sed '1d' | grep $now | awk '{print $1}' | sort -u | sed '/^$/d' >/data/offshore_support/Job_monitor/output`;

OUTPUT2=`ssh -q root@10.23.80.70 "/opt/tms/bin/pmx subshell oozie show workflow FAILED jobs"| grep -vE 'grep|No' | awk '{print $2, $10, $11}'| sed '1d' | grep $now | awk '{print $1}' | sort -u | sed '/^$/d' >/data/offshore_support/Job_monitor/output2`;

OUTPUT3=`ssh -q root@10.23.80.70 "/opt/tms/bin/pmx subshell oozie show workflow RUNNING jobs"| grep -vE 'grep|No' | awk '{print $2, $10, $11}'| sed '1d' | grep $now | awk '{print $1}' | sort -u | sed '/^$/d' >/data/offshore_support/Job_monitor/output3`;


newT=`comm -23 /data/offshore_support/Job_monitor/output /data/offshore_support/Job_monitor/output3`
if [ "$newT" ]
then
	echo "On $now jobs KILLED - $newT" | mail -s "List of KILLED jobs on $now" -r Sprint_production-admin@guavus.com samuel.joseph@guavus.com robert.phillips@guavus.com jatinder.singh@guavus.com eric.darby@guavus.com   mohsin.ali@guavus.com
else
	echo "no job KILLED"
fi


newT1=`comm -23 /data/offshore_support/Job_monitor/output2 /data/offshore_support/Job_monitor/output3`
if [ "$newT1" ]
then
        echo "On $now jobs FAILED - $newT1" | mail -s "List of FAILED jobs on $now" -r Sprint_production-admin@guavus.com samuel.joseph@guavus.com robert.phillips@guavus.com jatinder.singh@guavus.com eric.darby@guauvs.com mohsin.ali@guavus.com
else
        echo "no job FAILED"
fi
