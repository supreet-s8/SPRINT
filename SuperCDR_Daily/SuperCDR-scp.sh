#!/bin/bash

SSH1=`ls -lrth /data/superCDR_Daily/ |grep csv|tail -1 |awk '{print $NF}'`
SSH=`ssh root@10.23.80.67 "ls -lrth /data/superCDR_Daily/ "|grep csv|tail -1|awk '{print $NF}'`
LIST=`ls -lrth /data/superCDR_Daily/|grep csv|tail -1|awk '{print $NF}'|awk -F "-" '{print $NF}'|sed 's/.csv//g'`
SIZE=`ssh root@10.23.80.67 "ls -lrth /data/superCDR_Daily/"|grep csv|awk '{print $5}'|tail -1|tr 'aA-zZ' ' '`

if [ "$SSH1" == "$SSH" ]
	then
	echo "Files names are same on local and remote machine"
	echo " "
	echo "$SSH1  == $SSH "
	echo " "	

else

		last_date=`ls -lrth /data/superCDR_Daily/|grep csv|tail -1|awk '{print $NF}'|awk -F "-" '{print $NF}'|sed 's/.csv//g'`
                next_date=`date -d"${last_date} +1 day" +"%Y%m%d"`		
		LIST=`ssh -q  root@10.23.80.67 "ls -lrth /data/superCDR_Daily/superCDR_daily-\`echo ${next_date}\`.csv"`
		SIZE=`echo  "${LIST}"|awk '{print $5}'|tail -1|tr 'aA-zZ' ' '`
		if [ $? -eq 0 ] 
		
		then
			if [ ${SIZE} -ge 16 ]
			then
				scp root@10.23.80.67:/data/superCDR_Daily/superCDR_daily-`echo $next_date`.csv  /data/superCDR_Daily/
				echo "getting file from remote location"	
				sleep 3

				sed -i '1s/^/year month day hour rec_type rec_count sub_count onex_bytes onex_conn_cnt_tot onex_conn_dur_tot do_bytes do_conn_cnt_tot do_conn_dur_tot roam_bytes roam_conn_cnt_tot roam_conn_dur_tot     ehrpd_bytes lte_bytes wimax_bytes call_count mous threeg_onex_flag_tot threeg_do_flag_tot threeg_roam_flag_tot LTE_ehrpd_flag_tot LTE_lte_flag_tot wimax_flag_tot voice_flag_tot sms_flag_tot\n/' /data/superCDR_Daily/`/bin/ls -lrth /data/superCDR_Daily/ |grep csv|tail -1|awk '{print $NF}'`
				sleep 5

				echo "Please find attached SuperCDR Daily Report" |mail -a "/data/superCDR_Daily/`/bin/ls -lrth /data/superCDR_Daily/ |grep csv|tail -1|awk '{print $NF}'`" -s "SuperCDR Daily Report" -r sprint.production.monitoring@guavus.com gds-india@guavus.com erik.maxwell@guavus.com kevin.keschinger@guavus.com vishal.gupta@guavus.com robert.phillips@guavus.com mohsin.ali@guavus.com eric.darby@guavus.com
			else
				echo " Size not greater or equals to 16K"
			fi
		fi
fi
