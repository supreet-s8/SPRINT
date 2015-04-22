#!/bin/sh

 # collector stats instance-id 1 adaptor-stats lteIpdr num-files-processed interval-type 1-hour
# collector stats instance-id 1 adaptor-stats lteIpdr num-files-with-errors  interval-type 1-hour
 # collector stats instance-id 1 adaptor-stats lteIpdr average-flow-rate   interval-type 1-hour

pth="/data/offshore_support/CollectorStats/"
dt=`date +"%Y-%m-%d"`
time=`date +"%T"`
SSH1="ssh -q root@10.23.80.11 "
if [ ! -f ${pth}col_stat_CDMAIPDR_${dt}.csv ]
then
	echo "DATE,TIME,SERVERIP,NUMBER OF FILES PROCESSED,NUMBER OF FILES PROCESSED WITH ERROR,KFPS,TOTAL FLOW,DROP FLOW,DROP %" > ${pth}col_stat_CDMAIPDR_${dt}.csv
fi

if [ ! -f ${pth}col_stat_WIMAX_${dt}.csv ] 
then
	echo "DATE,TIME,SERVERIP,NUMBER OF FILES PROCESSED,NUMBER OF FILES PROCESSED WITH ERROR,KFPS,TOTAL FLOW,DROP FLOW,DROP %" > ${pth}col_stat_WIMAX_${dt}.csv
fi

if [ ! -f ${pth}col_stat_LTEIPDR_${dt}.csv ]
then
        echo "DATE,TIME,SERVERIP,NUMBER OF FILES PROCESSED,NUMBER OF FILES PROCESSED WITH ERROR,KFPS,TOTAL FLOW,DROP FLOW,DROP %" > ${pth}col_stat_LTEIPDR_${dt}.csv
fi

if [ ! -f ${pth}col_stat_CDMAVOICE_${dt}.csv ]
then
        echo "DATE,TIME,SERVERIP,NUMBER OF FILES PROCESSED,NUMBER OF FILES PROCESSED WITH ERROR,KFPS,TOTAL FLOW,DROP FLOW,DROP %" > ${pth}col_stat_CDMAVOICE_${dt}.csv
fi

check=`$SSH1 "/opt/tms/bin/cli -m config -t 'show pm process collector'" | grep status | awk -F: '{print $NF}'`

if [ $check == running ]
then
	for i in cdmaIpdr wimax lteIpdr cdmaVoice
	do
		d=`$SSH1 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $i num-files-processed interval-type 1-hour'"|tail -1|awk '{print $2}'`
		t=`$SSH1 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $i num-files-processed interval-type 1-hour'"|tail -1|awk '{print $3}'`	
		nofp=`$SSH1 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $i num-files-processed interval-type 1-hour'"|tail -1|awk '{print $NF}'`
		nofpe=`$SSH1 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $i num-files-with-errors interval-type 1-hour'"|tail -1|awk '{print $NF}'`
		#avg=`$SSH1 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $i average-flow-rate interval-type 1-hour'"|tail -1|awk '{print $NF}'`
		#kfps=`expr $avg / 60 / 1024`
		tf=`$SSH1 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $i total-flow interval-type 1-hour'"|tail -1|awk '{print $NF}'`
		kfps=`expr $tf / 3600 / 1024`
		df=`$SSH1 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $i dropped-flow interval-type 1-hour'"|tail -1|awk '{print $NF}'`
		if [ $tf -ne 0 ]
		then
			#dfp=`expr $df / $tf \* 100`
			dfp=`expr $df \* 100 / $tf`
		else
			dfp=0
		fi
		file=`echo $i|tr [a-z] [A-Z]`
		echo "$d,$t,10.23.80.70,$nofp,$nofpe,$kfps,$tf,$df,$dfp" >> ${pth}col_stat_${file}_${dt}.csv
	done

else
	echo "$dt,$time,10.23.10.70,=\"-0\",=\"-0\",=\"-0\",=\"-0\",=\"-0\",=\"-0\"" >> ${pth}col_stat_CDMAIPDR_${dt}.csv
	echo "$dt,$time,10.23.10.70,=\"-0\",=\"-0\",=\"-0\",=\"-0\",=\"-0\",=\"-0\"" >> ${pth}col_stat_WIMAX_${dt}.csv
	echo "$dt,$time,10.23.10.70,=\"-0\",=\"-0\",=\"-0\",=\"-0\",=\"-0\",=\"-0\"" >> ${pth}col_stat_LTEIPDR_${dt}.csv
	echo "$dt,$time,10.23.10.70,=\"-0\",=\"-0\",=\"-0\",=\"-0\",=\"-0\",=\"-0\"" >> ${pth}col_stat_CDMAVOICE_${dt}.csv
fi
