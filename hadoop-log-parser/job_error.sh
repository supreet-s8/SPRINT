#!/bin/sh
exec 1>/data/offshore_support/hadoop-log-parser/tmp.txt  
DIR="/data/offshore_support/hadoop-log-parser"
if [ -e ${DIR}/logs.txt ]
then
	rm -f ${DIR}/logs.txt
	rm -f ${DIR}/out.txt
fi


sys_prev_date=`ssh -q root@10.23.80.4 "date -d\"1 day ago\" +'%F'"`
sys_prev_date_sas=`ssh -q root@10.23.80.4 "date -d\"2 days ago\" +'%F'"`
epc_sys_prev_date=`date +%s -d"${sys_prev_date}"`
epc_sys_prev_date_sas=`date +%s -d"${sys_prev_date_sas}"`


job_date=`ssh -q root@10.23.80.4 "/opt/tms/bin/pmx subshell oozie show workflow SUCCEEDED jobs|grep -w NER|head -1"|awk '{print $8}'`
job_epc=`date +%s -d"${job_date}"`


if [ $epc_sys_prev_date -eq $job_epc ]
then
	job_dir=`ssh -q root@10.23.80.4 "/opt/tms/bin/pmx subshell oozie show workflow SUCCEEDED jobs|grep -w NER|head -1"|awk '{print $1}'`
	ssh -q root@10.23.80.4 "grep -ir -A 100  skipped /data/oozie-admi/${job_dir}" >> ${DIR}/logs.txt

fi


job_date_sas=`ssh -q root@10.23.80.4 "/opt/tms/bin/pmx subshell oozie show workflow SUCCEEDED jobs|grep -w NAESasCubes|head -1"|awk '{print $8}'`
job_epc_sas=`date +%s -d"${job_date}"`

if [ $epc_sys_prev_date_sas -eq $job_epc_sas ]
then

	job_dir=`ssh -q root@10.23.80.4 "/opt/tms/bin/pmx subshell oozie show workflow SUCCEEDED jobs|grep -w NAESasCubes|head -1"|awk '{print $1}'`
        ssh -q root@10.23.80.4 "grep -ir -A 100 skipped /data/oozie-admi/${job_dir}" >> ${DIR}/logs.txt

fi

if [ -s ${DIR}/logs.txt ]
then
	perl /data/offshore_support/hadoop-log-parser/log_parser.pl $DIR/logs.txt
	echo "Please find the attached Sprint Wireless hadoop skipped files" | mail -a /data/offshore_support/hadoop-log-parser/out.txt -s "Sprint Wireless hadoop skipped files" -r sprint.production.monitoring@guavus.com jatinder.singh@guavus.com samuel.joseph@guavus.com vishal.gupta@guavus.com kevin.keschinger@guavus.com mohsin.ali@guavus.com eric.darby@guavus.com robert.phillips@guavus.com manish.sharma@guavus.com
fi

