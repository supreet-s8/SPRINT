#!/bin/sh

clear

echo 'Collecting system health data. Generated results can be found under : /data/offshore_support/GDS/MonitoringScript/Monitoring_Output/NAE`date +%Y-%m-%d-%H`.txt'

exec 1>/data/offshore_support/GDS/MonitoringScript/Monitoring_Output/NAE`date +%Y-%m-%d-%H`.txt
SSH1='ssh -q root@10.23.80.11 '
DATE='201[4-5]/[0-9][0-9]'

echo '########  NAE COLLECTOR LAG  ########'
echo ' '
sh /data/offshore_support/GDS/MonitoringScript/helperScript/collectorLag.sh

echo ' '
echo '#############################################'
sleep 10

$SSH1 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats lteIpdr total-flow interval-type 1-hour interval-count 10'"
echo ' '
echo 'lteIpdr should be less than 5% of total flow for that hour.'
echo ' ' 
$SSH1 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats lteIpdr dropped-flow interval-type 1-hour interval-count 10'"
echo '#############################################'
echo ' '
$SSH1 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats cdmaVoice total-flow interval-type 1-hour interval-count 10'"
echo ' '
echo 'cdmaVoice should be less than 5% of total flow for that hour.'
echo ' '
$SSH1 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats cdmaVoice dropped-flow interval-type 1-hour interval-count 10'"
echo '#############################################'
echo ' '
$SSH1 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats cdmaIpdr total-flow interval-type 1-hour interval-count 10'"
echo ' '
echo 'cdmaIpdr should be less than 5% of total flow for that hour.'
echo ' '
$SSH1 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats cdmaIpdr dropped-flow interval-type 1-hour interval-count 10'"
echo '#############################################'
echo ' '
$SSH1 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats wimax total-flow interval-type 1-hour interval-count 10'"
echo ' '
echo 'Drop should be less than 5% of total flow for that hour.'
echo ' '
$SSH1 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats wimax dropped-flow interval-type 1-hour interval-count 10'" 
echo '#############################################'
echo ' ' 
echo '#############################################'
echo 'Last 10 Hadoop Disk Usage for LTE Adaptor (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/lte/$DATE/ 2>/dev/null|tail -10
echo '#############################################'
echo 'Last 10 Closed Bins for LTE Adaptor'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/lte/$DATE/ 2>/dev/null |grep _DONE |tail -10

echo '#############################################'
echo 'Last 10 Hadoop Disk Usage  for IPDR Adaptor (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/ipdr/$DATE/ 2>/dev/null|tail -10

echo '#############################################'
echo 'Last 10 Closed Bins  for IPDR Adpator'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/ipdr/$DATE/ 2>/dev/null |grep _DONE |tail -10


echo '#############################################'
echo 'Last 10 Hadoop Disk Usage for WIMAX Adaptor (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/wimax/$DATE/ 2>/dev/null|tail -10

echo '#############################################'
echo 'Last 10 Closed Bins for WIMAX Adaptor'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/wimax/$DATE/ 2>/dev/null |grep _DONE|tail -10

echo '#############################################'
echo 'Last 10  Hadoop Disk Usage for VOICE Adaptor (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/voice/$DATE/ 2>/dev/null|tail -10

echo '#############################################'
echo 'Last 10 Closed Bins for VOICE Adaptor'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/voice/$DATE/ 2>/dev/null |grep _DONE|tail -10


echo ' '
echo '####### NER job output [NER APP]  ########'
echo ' '

echo '#############################################'
echo 'Last 10 output size for merge_ipdr (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/cubes/merge_ipdr/$DATE/ 2>/dev/null|tail -10

echo '#############################################'
echo 'Last 10 output size for merge_lte (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/cubes/merge_lte/$DATE/ 2>/dev/null|tail -10

echo '#############################################'
echo 'Last 10 output size for merge_wimax (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/cubes/merge_wimax/$DATE/ 2>/dev/null|tail -10

echo '#############################################'
echo 'Last 10 output size for merge_voice (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/cubes/merge_voice/$DATE/ 2>/dev/null|tail -10

echo '#############################################'
echo 'Last 10 output size for basecube (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/cubes/basecube/$DATE/ 2>/dev/null|tail -10
echo ' '
echo '#############################################'
echo '####### NERExportJob job output [NER APP]  ########'
echo ' '
echo 'Last 10 output size for subCount (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/cubes/subCount/$DATE/ 2>/dev/null|tail -10
echo '#############################################'
echo ' '
echo '#############################################'
echo '####### RRExportJob job output [NER APP]  ########'
echo ' '
echo 'Last 10 output size for RRAggregated (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/cubes/RRAggregated/$DATE/ 2>/dev/null|tail -10
echo '#############################################'
echo ' '
echo '#############################################'
echo '####### RR job output [NER APP]  ########'
echo ' '
echo 'Last 10 output size for Basecube (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/cubes/Basecube/$DATE/ 2>/dev/null|tail -10
echo '#############################################'
echo ' '
echo '######## NAESasCubes job output [SAS APP]  ###########'
echo ' '
echo '#############################################'
echo 'Last 10 output size for mergeFeed Action (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/sas/mergeFeed/$DATE/ 2>/dev/null|tail -10
echo '#############################################'
echo 'Last 10 output size for baseCube Action (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/sas/baseCube/$DATE/ 2>/dev/null|tail -10
echo '#############################################'
echo 'Last 10 output size for RISE Action (If Zero is seen that means Data has been purged)'
echo '#############################################'
/opt/hadoop/bin/hadoop dfs -du /data/sas/rise/$DATE/ 2>/dev/null|tail -10
echo ' '
echo '#############################################'
echo '#############################################'
echo '############# Current JobStatus #############'
echo '#############################################'
sh /data/offshore_support/GDS/MonitoringScript/helperScript/getJobsStatus.sh


echo '#############################################'
echo '###### Checking Disk File System Usage ######'
echo '#############################################'
sh /data/offshore_support/GDS/MonitoringScript/helperScript/diskSpace.sh

echo '#############################################'
echo '######### Checking Hadoop Health ############'
echo '#############################################'
sh /data/offshore_support/GDS/MonitoringScript/helperScript/hadoopHealth.sh

echo ' '
echo '#############################################'
echo '######### NER Actual date on UI #############'
echo '#############################################'
a=`ssh -q root@10.23.80.136 "grep -w 'NerActual={=Interval' /data/instances/spw/1/bin/nae.log" |tail -1 |awk -F 'NerActual=' '{print $NF}' |awk -F 'endTime=' '{print $2}'|awk -F ',' '{print $1,$2}'`
b=`date +%s -d"$a"`
c=`expr $b - 86400`
date -d@"$c"

echo ' '
echo '#############################################'
echo '########### RR Actual date on UI ############'
echo '#############################################'
e=`ssh -q root@10.23.80.136 "grep -w 'RrBinDaily={=Interval' /data/instances/spw/1/bin/nae.log" |tail -1 |awk -F 'RrBinDaily={=Interval' '{print $NF}'|awk -F 'endTime=' '{print $NF}'|awk -F ',' '{print $1,$2}'`
f=`date +%s -d"$e"`
g=`expr $f - 86400`
date -d@"$g"


echo ' '
echo '############################################'
echo 'Checking Read/Write mode of Mount-Points'
echo '############################################'
sh /data/offshore_support/GDS/MonitoringScript/helperScript/mountPoint.sh


echo '############################################'
echo '########## Checking SAS System  ############'
echo '   '
echo '############################################'
sh /data/offshore_support/GDS/MonitoringScript/helperScript/SAS_hadoopHealth.sh
echo '  '
echo '############################################'
sh /data/offshore_support/GDS/MonitoringScript/helperScript/SAS_mountPoint.sh
echo '  '
echo '############################################'
sh /data/offshore_support/GDS/MonitoringScript/helperScript/SAS_diskSpace.sh
echo '  '
echo '############################################'
sh /data/offshore_support/GDS/MonitoringScript/helperScript/SAS_DU_HDFS.sh
echo '############################################'

echo '############################################'
echo '########## Checking CA System  ############'
echo '   '
echo '############################################'
ssh -q root@10.23.80.73 "/data/offshore_support/CA_hadoopHealth.sh"
echo '  '
echo '############################################'
ssh -q root@10.23.80.73 "/data/offshore_support/CA_mountPoint.sh"
echo '  '
echo '###########################################'
ssh -q root@10.23.80.73 "/data/offshore_support/CA_diskSpace.sh"
echo '  '
echo '############################################'
ssh -q root@10.23.80.73 "/data/offshore_support/CA_collectorLag.sh"
echo '############################################'

