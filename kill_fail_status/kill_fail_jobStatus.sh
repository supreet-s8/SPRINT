#!/bin/bash

#set -vx> /data/offshore_support/kill_fail_status/logs

#echo "================"
#echo " "
#echo "Failed Jobs if any on Master name nodes 10.23.80.70"
now=`date +%Y-%m-%d`
#now="2015-02-18"
#echo $now

path=/data/offshore_support/kill_fail_status/

if [ -f ${path}out.txt ]
then
	rm -f ${path}out.txt
fi

function checkjob
{
#echo "in check function"

	file=$1
	#echo $file
	#for i in `cat $file`
	while read i
	do
		#echo $i
		job=`echo $i|awk '{print $1}'`
		jobid=`echo $i | awk '{print $NF}'`
		status=`echo $i | awk '{print $2}'`
		#echo $job
		workflow=`/opt/tms/bin/pmx subshell oozie show workflow RUNNING jobs |grep -w $job |awk '{print $1}'`
		sleep 3
		coordinator=`/opt/tms/bin/pmx subshell oozie show coordinator RUNNING jobs |grep -w $job|awk '{print $1}'`
		if [[ ! $workflow ]] && [[ ! $coordinator ]]
		then
			echo "$job is neither in workflow nor in  coordinator, Job is NOT RUNNING" >> ${path}out.txt
		else
			if [ -f ${path}check_${now}.txt ]
			then
				out=`cat ${path}check_${now}.txt|grep $jobid`
				if [[ ! $out ]]
				then
					echo "$job was $status with this $jobid, But job is now RUNNING  $coordinator" >> ${path}out.txt
					echo "$job $jobid" >> ${path}check_${now}.txt
				fi
			else
				echo " $job is now  RUNNING with  $coordinator " >> ${path}out.txt
				echo "$job $jobid" >> ${path}check_${now}.txt	
			fi
		fi
		
	done < $file

}

if [ -f ${path}tmp.txt ]
then
	rm -f ${path}tmp.txt
fi

		
ssh -q root@10.23.80.70 "/opt/tms/bin/pmx subshell oozie show workflow FAILED jobs" | sed 1d|grep -v ^- |grep $now |awk '{print $2,$12,$13,$1}' >> ${path}tmp.txt
ssh -q root@10.23.80.70 "/opt/tms/bin/pmx subshell oozie show workflow KILLED jobs" |sed 1d|grep -v ^- |grep $now |awk '{print $2,$12,$13,$1}' >> ${path}tmp.txt
ssh -q root@10.23.80.70 "/opt/tms/bin/pmx subshell oozie show coordinator FAILED jobs" | sed 1d|grep -v ^- |grep $now |awk '{print $2,$16,$14,$1}' >> ${path}tmp.txt
ssh -q root@10.23.80.70 "/opt/tms/bin/pmx subshell oozie show coordinator KILLED jobs" |sed 1d|grep -v ^- |grep $now |awk '{print $2,$16,$14,$1}' >> ${path}tmp.txt

if [ -s ${path}tmp.txt ]
then
	#cat ${path}tmp.txt

#echo "--------------"

	if [ -f ${path}tmp1.txt ]
	then
		diff tmp.txt tmp1.txt |grep "<" | cut -d"<" -f2 | sed 's/^\s//g' > ${path}diff.txt
		
		if [ -s ${path}diff.txt ]
		then
			echo "Job failed/killed" >> ${path}out.txt
			echo "---------" >> ${path}out.txt
			cat ${path}tmp.txt >> ${path}out.txt 
		else
			checkjob ${path}tmp.txt
		fi
	else
		echo "Jobs Failed/killed" >> ${path}out.txt
		echo "----------" >> ${path}out.txt
		cat ${path}tmp.txt >> ${path}out.txt
	fi
#cat ${path}tmp.txt > ${path}tmp1.txt

fi

cat ${path}tmp.txt > ${path}tmp1.txt

if [ -f ${path}out.txt ]
then
	uniq ${path}out.txt > ${path}$$ ; rm -f ${path}out.txt ; mv -f ${path}$$ ${path}out.txt
	cat ${path}out.txt| grep -vi not > ${path}out_running.txt 
	cat ${path}out.txt| grep -i not >  ${path}out_NOT.txt
	rec=`cat /data/offshore_support/configuration/email/internal | tr '\n' ' '`
	if [ -s ${path}out_running.txt ]
	then	
		scp -q  ${path}out_running.txt root@10.23.80.24:${path}
		ssh -q root@10.23.80.24 "cat ${path}out_running.txt|mail -s 'RUNNING Jobs' -r sprint.production.monitoring@guavus.com $rec"
	fi
	if [ -s ${path}out_NOT.txt ]
	then
		scp -q ${path}out_NOT.txt root@10.23.80.24:${path}
		ssh -q root@10.23.80.24 "cat ${path}out_NOT.txt|mail -s 'Failed/Killed Jobs' -r sprint.production.monitoring@guavus.com $rec"
	fi
	#rec=`cat /data/offshore_support/configuration/email/internal | tr '\n' ' '`
	#ssh -q root@10.23.80.24 "cat ${path}out.txt|mail -s 'Failed/Killed Jobs' -r sprint.production.monitoring@guavus.com gaurav.babbar@guavus.com samuel.joseph@guavus.com jatinder.singh@guavus.com"
	#ssh -q root@10.23.80.24 "cat ${path}out.txt|mail -s 'Failed/Killed Jobs' -r sprint.production.monitoring@guavus.com $rec"
#	ssh -q root@10.23.80.24 "cat ${path}out.txt|mail -s 'Failed/Killed Jobs' -r sprint.production.monitoring@guavus.com gaurav.babbar@guavus.com jatinder.singh@guavus.com"
	ssh -q root@10.23.80.24 "rm -rf  ${path}out_running.txt"	
	ssh -q root@10.23.80.24 "rm -rf  ${path}out_NOT.txt"	
fi
