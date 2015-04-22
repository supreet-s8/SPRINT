#!/bin/sh

echo "JOB NAME,JOB ID,START TIME,END TIME,TIME TAKEN IN HOURS" > /data/offshore_support/timetaken/time_taken.csv

for i in `cat /data/offshore_support/timetaken/job-name`
do
	 
	ID=`/opt/tms/bin/pmx subshell oozie show workflow all jobs | grep -w ${i} | grep -w SUCCEEDED| head -1 | awk '{print $1}'`
	start=`ls -lrth /data/oozie-admi/${ID}| grep checkdone--ssh | awk '{print $6,$7,$8}'`
	end=`ls -lrth /data/oozie-admi/${ID} | grep -w done--ssh | awk '{print $6,$7,$8}'`
	starttime=`date +%s -d"$start"`
	endtime=`date +%s -d"$end"`
	diff=`expr $endtime - $starttime`
	calc=`echo "$diff / 3600" | bc`
	echo "${i},${ID},${start},${end},${calc}" >> /data/offshore_support/timetaken/time_taken.csv
done

## copy csv to management
scp -q /data/offshore_support/timetaken/time_taken.csv  root@10.23.80.24:/data/offshore_support/timetaken/

## send mail

ssh -q root@10.23.80.24 "echo "PFA report. This is monitor will get the time taken by a job in hours."|mail -s 'Time Taken by job' -a /data/offshore_support/timetaken/time_taken.csv  -r sprint.production.monitoring@guavus.com gaurav.babbar@guavus.com samuel.joseph@guavus.com jatinder.singh@guavus.com"

## remove csv
rm -rf /data/offshore_support/timetaken/time_taken.csv

