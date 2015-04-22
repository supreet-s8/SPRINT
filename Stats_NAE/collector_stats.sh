#!/bin/sh

dt=`date +"%Y-%m-%d"`
for i in LTEIPDR WIMAX CDMAVOICE CDMAIPDR 
	do 

	scp -q root@10.23.80.4:/data/offshore_support/CollectorStats/`ssh -q root@10.23.80.4 " ls /data/offshore_support/CollectorStats/"|grep col_stat_${i}_${dt}`  /data/offshore_support/CollectorStats/ 

	
done

LTEIPDR=`ls -lrth /data/offshore_support/CollectorStats/|grep LTEIPDR|awk '{print $NF}'|tail -1`
WIMAX=`ls -lrth /data/offshore_support/CollectorStats/|grep WIMAX |awk '{print $NF}'|tail -1`
CDMAVOICE=`ls -lrth /data/offshore_support/CollectorStats/ |grep CDMAVOICE |awk '{print $NF}'|tail -1`
CDMAIPDR=`ls -lrth /data/offshore_support/CollectorStats/|grep CDMAIPDR|awk '{print $NF}'|tail -1`



echo "PFA COLLECTOR DAILY DETAILED REPORT" |mail -a  /data/offshore_support/CollectorStats/${LTEIPDR} -a  /data/offshore_support/CollectorStats/${WIMAX} -a  /data/offshore_support/CollectorStats/${CDMAVOICE} -a  /data/offshore_support/CollectorStats/${CDMAIPDR} -s "Collector Daily Demography" -r sprint.production.monitoring@guavus.com gaurav.babbar@guavus.com jatinder.singh@guavus.com samuel.joseph@guavus.com


