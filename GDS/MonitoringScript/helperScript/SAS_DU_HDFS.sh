#!/bin/sh
echo "########## Checking HDFS Disk Size #########"
ssh -q root@10.23.80.67 "/opt/sas/hadoop-0.20.204.0/bin/hadoop dfs -du /data/cubes/sasCDRCube/year=2015/month=[0-1][0-9]/"|grep "day="  |tail
echo "############################################"
echo  " "
 for i in mvno prepaid postpaid
	do
		echo "Last 2 HDFS Disk Size For Rise ($i)";
		ssh -q root@10.23.80.67 "/opt/sas/hadoop-0.20.204.0/bin/hadoop dfs -du /data/cubes/rise/$i/year=2015/month=[0-9][0-9]"|tail -2;
		echo "    ";
done
echo " "
echo "############################################"
echo "### Total number of MapReduce files = 48 ###"
echo "############################################"

Lst_Dir=`ssh -q root@10.23.80.67 "/opt/sas/hadoop-0.20.204.0/bin/hadoop dfs -ls /data/cubes/sasCDRCube/year=2015/month=[0-1][0-9]/" |tail -2|head -1|awk '{print $NF}'`
	echo " "
	#Count=`ssh -q root@10.23.80.67 "/opt/sas/hadoop-0.20.204.0/bin/hadoop dfs -lsr $Lst_Dir |grep -w MAPREDUCE |grep -v '_distcp_tmp'|grep -vE 'hour|X.MAPREDUCE.0.47' |wc -l"`
	Count=`ssh -q root@10.23.80.67 "/opt/sas/hadoop-0.20.204.0/bin/hadoop dfs -lsr $Lst_Dir |grep -w MAPREDUCE |wc -l"`
if [ "$Count" == 48 ]
	then
	echo "Number of files per day = PASS"
	else
	echo "Number of files per day = FAIL  and $Lst_Dir  : $Count"
fi

echo " "
echo "############################################"
echo "######### Script working directory #########" 
echo "############################################"
ssh -q root@10.23.80.67 "/opt/sas/hadoop-0.20.204.0/bin/hadoop dfs -du /data/cubes/sasCDRCube/year=2015/month=[0-1][0-9]/day=[0-9][0-9]/ |grep -w 'day'| grep -v '_distcp_'|tail -4 |awk '{print $NF}'"
echo "############################################"
