#!/bin/sh

echo "##################################################"
echo " "
echo "Failed Jobs if any on Master name nodes 10.23.80.70"
echo " "
echo "##################################################"
now=`date +%Y-%m-%d`
ssh -q root@10.23.80.70 " /opt/tms/bin/pmx subshell oozie show workflow all jobs |grep -E 'KILLED|JOB LAG STATUS : FAILED' |grep `date -d '8 hour ago' +%Y-%m-%d`"|awk '{print $1 " " $2}'

echo " "

ssh -q root@10.23.80.70 "/opt/tms/bin/pmx subshell oozie show workflow RUNNING jobs" | sed '1d' | awk '{print $2}' >jobList
sed -i '/^[[:space:]]*$/d;s/[[:space:]]*$//' jobList

echo "#######################################"
echo "List of running jobs with last run time"
echo "#######################################"

filename=jobList

dt=`date +%Y-%m-%d'T'%T`
echo "##### Current System Time - $dt ########"
echo " "
echo "########## Job Status ############"
echo " "

#for i in `cat jobList`
#do
	#timeJ=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/$i/done.txt" 2>/dev/null`; echo "$i : $timeJ"

C1=`ssh -q root@10.23.80.70 "date --date='2 day ago' '+%Y-%m-%d'"`
B1=`ssh -q root@10.23.80.70 "date --date='8 day ago' '+%Y-%m-%d'"`
A1=`ssh -q root@10.23.80.70 "date --date='2 day ago' '+%Y-%m-%d'"`
Mon=`ssh -q root@10.23.80.70 "date '+%Y-%m'"`
/opt/tms/bin/pmx subshell oozie show workflow RUNNING jobs | awk '{print $1,$2}'  >Running_jobs.txt
JOB=`cat Running_jobs.txt |grep -w NER |cut -d" " -f 1`
A=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/NER/done.txt" 2>/dev/null |cut -d 'T' -f1`
if [[ "${A}" == "${A1}" ]];
then
echo "NER
	 JOB LAG STATUS : PASS 
	 $JOB"
else 
	if [[ "${A}" > "${A1}" ]]; then
		echo "NER 
	JOB LAG STATUS : PASS 
	$JOB"
	else
		echo "NER
	JOB LAG STATUS : FAIL 
	$JOB"
	fi
fi


B=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/NERExportJob/done.txt" 2>/dev/null |cut -d 'T' -f1`
JOB1=`cat Running_jobs.txt |grep -w NERExportJob |cut -d" " -f 1`
if [[ "$B" == "$A1" ]]
then
echo   "NERExportJob
	JOB LAG STATUS : PASS 
	$JOB1"
else
        if [[ "${B}" > "${A1}" ]]; then
                echo "NERExportJob 
	JOB LAG STATUS : PASS 
	$JOB1"
        else
                echo "NERExportJob
	JOB LAG STATUS : FAIL 
	$JOB1"
        fi
fi

JOB2=`cat Running_jobs.txt |grep -w RRExportJob |cut -d" " -f 1`
C=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/RRExportJob/done.txt" 2>/dev/null |cut -d 'T' -f1`
if [[ "$C" == "$B1" ]]
then
echo "RRExportJob
	JOB LAG STATUS : PASS
	$JOB2"
else
        if [[ "${C}" > "${B1}" ]]; then
                echo "RRExportJob
	JOB LAG STATUS : PASS 
	$JOB2"
        else
                echo "RRExportJob
	JOB LAG STATUS : FAIL
	$JOB2"
        fi
fi

JOB3=`cat Running_jobs.txt |grep -w RR |cut -d" " -f 1`
D=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/RR/done.txt" 2>/dev/null |cut -d 'T' -f1`
if [[ "$D" == "$B1" ]]
then
echo "RR
	JOB LAG STATUS : PASS
	$JOB3"
else
        if [[ "${D}" > "${B1}" ]]; then
                echo "RR
	JOB LAG STATUS : PASS
	$JOB3"
        else
                echo "RR
	JOB LAG STATUS : FAIL
	$JOB3"
        fi
fi
JOB4=`cat Running_jobs.txt |grep -w DeviceClientProcessData |cut -d" " -f 1`
E=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/DeviceClientProcessData/done.txt" 2>/dev/null |cut -d 'T' -f1`
if [[ "$E" == "$B1" ]]
then
echo "DeviceClientProcessData
	JOB LAG STATUS : PASS
	$JOB4"
else
	if [[ "$E" > "$B1" ]]; then
		echo "DeviceClientProcessData
	JOB LAG STATUS : PASS
	$JOB4"
	else
		echo "DeviceClientProcessData
	JOB LAG STATUS : FAIL
	$JOB4"
	fi
fi
#JOB5=`cat Running_jobs.txt |grep -w PullDataSmithMicroJob |cut -d" " -f 1`
#F=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/PullDataSmithMicroJob/done.txt" 2>/dev/null |cut -d 'T' -f1`
#if [[ "$F" == "$A1" ]]
#then
#echo "PullDataSmithMicroJob
#	JOB LAG STATUS : PASS
#	$JOB5"
#else
#echo "PullDataSmithMicroJob
#	JOB LAG STATUS : FAIL
#	$JOB5" 
#fi
#
#JOB6=`cat Running_jobs.txt |grep -w SmithMicro |cut -d" " -f 1`
#G=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/SmithMicro/done.txt" 2>/dev/null |cut -d 'T' -f1`
#if [[ "$G" == "$A1" ]]
#then
#echo "SmithMicro
#	JOB LAG STATUS : PASS
#	$JOB6"
#else
#echo "SmithMicro
#	JOB LAG STATUS : FAIL
#	$JOB6"
#fi
JOB7=`cat Running_jobs.txt |grep -w NAESasCubes |cut -d" " -f 1`
H=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/NAESasCubes/done.txt" 2>/dev/null |cut -d 'T' -f1`
if [[ "$H" == "$A1" ]]
then
echo "NAESasCubes
	JOB LAG STATUS : PASS
	$JOB7"
else
echo "NAESasCubes
	JOB LAG STATUS : FAIL
	$JOB7"
fi
JOB8=`cat Running_jobs.txt |grep -w SasCopyCDR |cut -d" " -f 1`
I=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/SasCopyCDR/done.txt" 2>/dev/null |cut -d 'T' -f1`
if [[ "$I" == "$A1" ]]
then
echo "SasCopyCDR
	JOB LAG STATUS : PASS
	$JOB8"
else
echo "SasCopyCDR
	JOB LAG STATUS : FAIL
	$JOB8"
fi
JOB9=`cat Running_jobs.txt |grep -w NerMonthReport |cut -d" " -f 1`
J=`ssh -q root@10.23.80.70 "hadoop dfs -cat /data/NerMonthReport/done.txt" 2>/dev/null |cut -d 'T' -f1|cut -d '-' -f1,2`
if [[ "$J" == "$Mon" ]]
then
echo "NerMonthReport
	JOB LAG STATUS : PASS
	$JOB9"
else
	if [[ "$J" == "$Mon" ]]; then
		echo "NerMonthReport
	JOB LAG STATUS : PASS
	$JOB9"
	else
		echo "NerMonthReport
	JOB LAG STATUS : FAIL
	$JOB9"
	fi
fi

#echo "========================="
echo " "
