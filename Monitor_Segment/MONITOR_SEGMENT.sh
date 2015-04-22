#!/bin/sh

DATE=`date`;
###################################################
#	rise file monitor
###################################################
dayago=`date -d '2 day ago' +'%Y/%m/%d'`
year=`echo $dayago|cut -d '/' -f1`
month=`echo $dayago|cut -d '/' -f2`
day=`echo $dayago|cut -d '/' -f3`

check_dir=`ssh -q root@10.23.80.70 "ls /data/rise/nae" | egrep 'mvno|prepaid|post' | wc -l`

HDFS=`ssh -q root@10.23.80.70 "hadoop dfs -du /data/input/rise/$year/$month/$day/  2>/dev/null"|egrep 'mvno|pre|post'|wc -l `

if  [ ${check_dir} -ne 3 ] && [ ${HDFS} -ne 3 ]
	then 
	echo "Rise files are missing from the directory at 10.23.80.70 /data/rise/nae --------`ssh -q root@10.23.80.70 "ls -lrt /data/rise/nae"`" | mail -s "Rise file monitor" -r Sprint_production-admin@guavus.com  noc.support@guavus.com eric.darby@guavus.com mohsin.ali@guavus.com samuel.joseph@guavus.com robert.phillips@guavus.com jatinder.singh@guavus.com kevin.keschinger@guavus.com


fi
