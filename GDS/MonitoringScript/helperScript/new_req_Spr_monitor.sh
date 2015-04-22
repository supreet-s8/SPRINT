#!/bin/sh
#created:2014-07-30
#owner:Jsingh
echo "----------"
echo "TIME ON UI"
echo "----------"
echo " "
NER=`ssh -q root@10.23.80.136 "grep -w 'NerActual={=Interval' /data/instances/spw/1/bin/nae.log" |tail -1 |awk -F "NerActual=" '{print $NF}' |awk -F "endTime=" '{print $2}'|awk -F "," '{print $1,$2}'`
RR=`ssh -q root@10.23.80.136 "grep -w 'RrBinDaily={=Interval' /data/instances/spw/1/bin/nae.log" |tail -1 |awk -F "RrBinDaily={=Interval" '{print $NF}'|awk -F "endTime=" '{print $NF}'|awk -F "," '{print $1,$2}'`

echo "NER : $NER" 
echo " "
echo "RR : $RR"

echo " "
echo "HADOOP-STATUS"
echo "------------ "
echo " "
/opt/hadoop/bin/hadoop dfsadmin -report 2>/dev/null |head -12 |grep -E "Datanodes available:|DFS Used%:|Missing blocks:|Blocks with corrupt replicas:"
echo " "
echo "LATEST_DONE"
echo "-----------"
echo " "
for i in lte ipdr voice wimax
	do
		echo "$i"
		hadoop dfs -lsr /data/collector/output/$i/2014/ 2>/dev/null|grep _DONE |tail -1 |awk -F " " '{print $NF}'
		echo " "
	done
echo " "
SAS=`ssh -q root@10.23.80.26 "/opt/sas/hadoop-0.20.204.0/bin/hadoop dfsadmin -report" 2>/dev/null |head -12 |grep -E "Datanodes available:|DFS Used%:|Missing blocks:|Blocks with corrupt replicas:"`

SAS1=`ssh -q root@10.23.80.26 "/bin/df -kh |grep -E 'data1|data2'  "|awk -F " " '{print $6,$5}'|head -2`

echo "SAS-HADOOP-STATUS"
echo "----------"
echo " "
echo "$SAS"
echo " "
echo "SAS-DISK-USAUGE"
echo " "
echo "$SAS1"

echo "--------------------"
