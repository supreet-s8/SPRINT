#!/bin/sh

clear

echo "Collecting system health data. Generated results can be found under : /data/GDS/MonitoringScript/Monitoring_Output/Monitoring`date +%Y-%m-%d-%H`.txt"

exec 1>/data/GDS/MonitoringScript/Monitoring_Output/Monitoring`date +%Y-%m-%d-%H`.txt


DATE='2014/[0-1][1-9]'
path='sh /data/GDS/MonitoringScript/helperScript'

echo "########  NAE COLLECTOR LAG  ########"

echo " "
$path/collectorLag.sh
echo " "

echo "#############################################"

/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats lteIpdr total-flow interval-type 1-hour interval-count 10"
echo " "
echo "lteIpdr should be less than 2% of total flow for that hour, if not then stop collector and call SamJ"
echo " " 
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats lteIpdr dropped-flow interval-type 1-hour interval-count 10"
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaVoice total-flow interval-type 1-hour interval-count 10"
echo " "
echo "cdmaVoice should be less than 10% of total flow for that hour, if not then stop collector and call SamJ"
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaVoice dropped-flow interval-type 1-hour interval-count 10"
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaIpdr total-flow interval-type 1-hour interval-count 10"
echo " "
echo "cdmaIpdr should be less than 10% of total flow for that hour, if not then stop collector and call SamJ"
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaIpdr dropped-flow interval-type 1-hour interval-count 10"
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats wimax total-flow interval-type 1-hour interval-count 10"
echo " "
echo "wimax should be less than 2% of total flow for that hour, if not then stop collector and call SamJ"
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats wimax dropped-flow interval-type 1-hour interval-count 10" 

echo "#############################################"
echo "Last 10 DU's for LTE"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/lte/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 Done's for LTE"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/lte/$DATE/ 2>/dev/null |grep _DONE |tail -10

echo "#############################################"
echo "Last 10 DU for IPDR"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/ipdr/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DONE for IPDR"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/ipdr/$DATE/ 2>/dev/null |grep _DONE |tail -10


echo "#############################################"
echo "Last 10 Du for WIMAX"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/wimax/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DU for WIMAX"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/wimax/$DATE/ 2>/dev/null |grep _DONE|tail -10

echo "#############################################"
echo "Last 10 DU for VOICE"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/voice/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DONE for VOICE"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/voice/$DATE/ 2>/dev/null |grep _DONE|tail -10

echo " "
echo "####### NER job output [NER APP]  ########"
echo " "

echo "#############################################"
echo "Last 10 du for merge_ipdr"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/cubes/merge_ipdr/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DU for merge_lte"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/cubes/merge_lte/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DU for merge_wimax"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/cubes/merge_wimax/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DU for merge_voice"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/cubes/merge_voice/$DATE/ 2>/dev/null|tail -10

echo " "
echo "######## NAESasCubes job output [SAS APP]  ###########"
echo " "

echo "#############################################"
echo "Last 10 DU for mergeFeed"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/sas/mergeFeed/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DU for baseCube"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/sas/baseCube/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DU for RISE"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/sas/rise/$DATE/ 2>/dev/null|tail -10

echo " "
echo "######## RR APP #####"
echo " "

echo "#############################################"
echo "Last 10 DU for Ciber"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/ciber/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DU for MergeIpdr"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/cubes/MergeIpdr/$DATE/ 2>/dev/null|tail -10

echo "#############################################"
echo "Last 10 DU for MergeCiber"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du  /data/cubes/MergeCiber/$DATE/ 2>/dev/null|tail -10
echo "#############################################"


echo "#############################################"
echo "Current JobStatus"
echo "#############################################"
$path/getJobsStatus.sh

echo "#############################################"
echo "RUNNING WORKFLOW JOBS"
echo "#############################################"
pmx subshell oozie show workflow RUNNING jobs | awk '{print $1,$2}'

echo "#############################################"
echo "Checking Disk Usage"
echo "#############################################"
$path/diskSpace.sh

echo "#############################################"
echo "Checking Hadoop Health"
echo "#############################################"
$path/hadoopHealth.sh

echo " "
echo "#############################################"
echo "NER Actual date on UI = date returned -1day"
echo "#############################################"
ssh -q root@10.23.80.136 "grep -w 'NerActual={=Interval' /data/instances/spw/1/bin/nae.log" |tail -1 |awk -F "NerActual=" '{print $NF}' |awk -F "endTime=" '{print $2}'|awk -F "," '{print $1,$2}'

echo " "
echo "#############################################"
echo "RR Actual date on UI = date returned -1day"
echo "#############################################"
ssh -q root@10.23.80.136 "grep -w 'RrBinDaily={=Interval' /data/instances/spw/1/bin/nae.log" |tail -1 |awk -F "RrBinDaily={=Interval" '{print $NF}'|awk -F "endTime=" '{print $NF}'|awk -F "," '{print $1,$2}'


echo " "
echo "############################################"
echo "Checking Mount-Points"
echo "############################################"
$path/mountPoint.sh
echo "############################################"
echo "Checking SAS_Box Health"
echo "############################################"
$path/SAShealth.py >SaS.txt
echo "############################################"
