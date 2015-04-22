#!/bin/sh

clear

echo "Collecting system health data. Generated results can be found under : /data/offshore_support/GDS/MonitoringScript/daily_Output/NAE`date +%Y-%m-%d-%H`.txt"

exec 1>/data/offshore_support/GDS/MonitoringScript/daily_Output/NAE`date +%Y-%m-%d-%H`.txt

DATE='201[4-5]/[0-9][0-9]'

echo "Current System Time  : `date`"
echo "################ COLLECTOR 10.23.80.4 #################"

echo " "
echo "#############################################"
echo "Last 3 Hadoop Disk Usage  for LTE Adaptor "
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/lte/$DATE/*/ 2>/dev/null|tail -3
echo "#############################################"
echo "Last 3 Closed Bins for LTE Adaptor"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/lte/$DATE/ 2>/dev/null |grep _DONE |awk '{print $NF}'|tail -3

echo "#############################################"
echo "Last 3 Hadoop Disk Usage  for IPDR Adaptor"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/ipdr/$DATE/*/ 2>/dev/null|tail -3

echo "#############################################"
echo "Last 3 Closed Bins  for IPDR Adpator"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/ipdr/$DATE/ 2>/dev/null |grep _DONE|awk '{print $NF}' |tail -3


echo "#############################################"
echo "Last 3 Hadoop Disk Usage for WIMAX Adaptor "
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/wimax/$DATE/*/ 2>/dev/null|tail -3

echo "#############################################"
echo "Last 3 Closed Bins for WIMAX Adaptor"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/wimax/$DATE/  2>/dev/null |grep _DONE|awk '{print $NF}'|tail -3

echo "#############################################"
echo "Last 3  Hadoop Disk Usage for VOICE Adaptor "
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -du /data/collector/output/voice/$DATE/*/ 2>/dev/null|tail -3

echo "#############################################"
echo "Last 3 Closed Bins for VOICE Adaptor"
echo "#############################################"
/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/voice/$DATE/ 2>/dev/null |grep _DONE|awk '{print $NF}'|tail -3
echo " "
echo "#############################################"
/opt/hadoop/bin/hadoop dfsadmin -report 2>/dev/null|head -12 |grep -i USED%

echo "############################################"
echo "Latest Processed file by Adaptor"
echo "############################################"
echo " "
echo "IPDR : `ls -lrth /data/feeds/collector/ipdr_replay/ |grep '.proc' |awk '{print $NF}'`"
echo "LTE : `ls -lrth /data/feeds/collector/lte_rest/ |grep '.proc' |awk '{print $NF}'`"
echo "VOICE : `ls -lrth /data/feeds/collector/voice_bkp/ |tail -1 |awk '{print $NF}'`"
echo "WIMAX : `ls -lrth /data/feeds/collector/wimax_bkp/ |tail -1 |awk '{print $NF}'`"
echo "############################################"
echo "	Disk Usage per  Adaptor (kilobyte)"
echo "############################################"
echo " "
for i in lte ipdr voice wimax 
	do
	echo " "
	echo "$i : `du -s /data/feeds/collector/${i} 2>/dev/null`"
	echo " "
done
	echo "/data/feeds/ : `df -kh |grep "/data/feeds"|awk '{print $5}'`"
	echo "/var/root/temp : `df -kh |grep "/var/root/tmp"|awk '{print $5}'`"
echo " "
echo "#############################################"
sleep 10


/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats lteIpdr total-flow interval-type 1-hour interval-count 24"
echo " "
echo "lteIpdr should be less than 5% of total flow for that hour."
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats lteIpdr dropped-flow interval-type 1-hour interval-count 24"
echo "#############################################"
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaVoice total-flow interval-type 1-hour interval-count 24"
echo " "
echo "cdmaVoice should be less than 5% of total flow for that hour."
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaVoice dropped-flow interval-type 1-hour interval-count 24"
echo "#############################################"
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaIpdr total-flow interval-type 1-hour interval-count 24"
echo " "
echo "cdmaIpdr should be less than 5% of total flow for that hour."
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaIpdr dropped-flow interval-type 1-hour interval-count 24"
echo "#############################################"
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats wimax total-flow interval-type 1-hour interval-count 24"
echo " "
echo "Drop should be less than 5% of total flow for that hour."
echo " "
/opt/tms/bin/cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats wimax dropped-flow interval-type 1-hour interval-count 24"
echo "#############################################"


echo " "
echo " "
echo "#############################################"
echo "############ NEW COLLECTOR  #################"
echo "#############################################"
echo "########### COLLECTOR 10.23.80.65 ###########"
echo " "
echo " "
echo "#############################################"

echo "Last 3 Hadoop Disk Usage  for LTE Adaptor "
echo "#############################################"
ssh -q root@10.23.80.65 "/opt/hadoop/bin/hadoop dfs -du /data/collector/output/lte_newcol_22_24/$DATE/*/ 2>/dev/null"|tail -5
echo "#############################################"
echo "Last 3 Closed Bins for LTE Adaptor"
echo "#############################################"

ssh -q root@10.23.80.65 "/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/lte_newcol_22_24/$DATE/ 2>/dev/null" |grep _DONE |awk '{print $NF}'|tail -5
echo "#############################################"
#
#echo "Last 3 Hadoop Disk Usage  for IPDR Adaptor"
#echo "#############################################"
#
#ssh -q root@10.23.80.65 "/opt/hadoop/bin/hadoop dfs -du /data/collector/output/ipdr_newcol/$DATE/*/ 2>/dev/null"|tail -3
#
#
#
#echo "#############################################"
#
#echo "Last 3 Closed Bins  for IPDR Adpator"
#echo "#############################################"
#ssh -q root@10.23.80.65 "/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/ipdr_newcol/$DATE/ 2>/dev/null "|grep _DONE|awk '{print $NF}' |tail -3
#
#
#echo "#############################################"
#echo "Last 3 Hadoop Disk Usage for WIMAX Adaptor "
#echo "#############################################"
#ssh -q root@10.23.80.65 "/opt/hadoop/bin/hadoop dfs -du /data/collector/output/wimax_newcol/$DATE/*/ 2>/dev/null"|tail -3
#
#echo "#############################################"
#echo "Last 3 Closed Bins for WIMAX Adaptor"
#echo "#############################################"
#ssh -q root@10.23.80.65 "/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/wimax_newcol/$DATE/  2>/dev/null" |grep _DONE|awk '{print $NF}'|tail -3
#
#echo "#############################################"
#echo "Last 3  Hadoop Disk Usage for VOICE Adaptor "
#echo "#############################################"
#ssh -q root@10.23.80.65 "/opt/hadoop/bin/hadoop dfs -du /data/collector/output/voice_newcol/$DATE/*/ 2>/dev/null"|tail -3
#
#echo "#############################################"
#echo "Last 3 Closed Bins for VOICE Adaptor"
#echo "#############################################"
#ssh -q root@10.23.80.65 "/opt/hadoop/bin/hadoop dfs -lsr /data/collector/output/voice_newcol/$DATE/ 2>/dev/null" |grep _DONE|awk '{print $NF}'|tail -3
#echo " "
#echo "#############################################"
#ssh -q root@10.23.80.65 "/opt/hadoop/bin/hadoop dfsadmin -report 2>/dev/null|head -12 |grep -i USED%

echo " "
ssh -q root@10.23.80.65 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats lteIpdr total-flow interval-type 1-hour interval-count 24'"
echo " "
echo "lteIpdr should be less than 5% of total flow for that hour."
echo " "
ssh -q root@10.23.80.65 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats lteIpdr dropped-flow interval-type 1-hour interval-count 24'"
echo "#############################################"


#echo " "
#ssh -q root@10.23.80.65 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats cdmaVoice total-flow interval-type 1-hour interval-count 24'"
#echo " "
#echo "cdmaVoice should be less than 5% of total flow for that hour."
#echo " "
#ssh -q root@10.23.80.65 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats cdmaVoice dropped-flow interval-type 1-hour interval-count 24'"
#echo "#############################################"
#echo " "
#ssh -q root@10.23.80.65 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats cdmaIpdr total-flow interval-type 1-hour interval-count 24'"
#echo " "
#echo "cdmaIpdr should be less than 5% of total flow for that hour."
#echo " "
#ssh -q root@10.23.80.65 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats cdmaIpdr dropped-flow interval-type 1-hour interval-count 24'"
#echo "#############################################"
#echo " "
#ssh -q root@10.23.80.65 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats wimax total-flow interval-type 1-hour interval-count 24'"
#echo " "
#echo "Drop should be less than 5% of total flow for that hour."
#echo " "
#ssh -q root@10.23.80.65 "/opt/tms/bin/cli -m config -t  'collector stats instance-id 1 adaptor-stats wimax dropped-flow interval-type 1-hour interval-count 24'"
#echo " "
#echo  " "
echo "#############################################"
echo "************ KFPS PER FEED ****************"
echo "#############################################" 
ssh -q root@10.23.80.65 "sh /tmp/kfps.sh"
echo "*******************************************"
echo "************ LOCAL DISK USAGE *************"
ssh -q root@10.23.80.65 "sh /tmp/du.sh"
#echo "*******************************************"
echo "*******************************************"
echo "*********** REPORT END'S HERE  ************"
#echo "*******************************************"
echo "*******************************************"
