#!/bin/bash

source /data/GDS/MonitoringScript/process_liveness/env
LOG="/data/GDS/MonitoringScript/process_liveness/log.txt"
if [ -e $LOG ]
then
	rm -f $LOG
fi
#### collector monitoring #######
for col in $gdssprcol1 $gdssprcol2
do
	status=`$SSH $col "$CLI -t 'en' 'show pm process collector'|grep -i 'Current status'|sed 's/\s//g'"|cut -d : -f2` 

#	echo "collector process $col : $status"
	if [[ "$status" != "running" ]]
	then
		echo "Collector process (${col}) : $status" >> $LOG
		echo " " >> $LOG	
	fi
	
	status1=`$SSH $col "$CLI -t 'en' 'show pm process tps'|grep 'Current status'|sed 's/\s//g'"|cut -d : -f2`
	echo "tps process $col : $status1"
        if [[ "$status1" != "running" ]]
        then
                echo "tps process (${col}) :  $status1 " >> $LOG
		echo " " >> $LOG
        fi

done


count=`$SSH $gdssprcol1 "ps -ef" |grep hadoop|egrep -i 'node|jobtracker'|grep -v grep |wc -l`
echo $count
#if [ $count -le 5 ]
if [ $count -eq 5 ]
then
	for i in datanode namenode secondarynamenode jobtracker
	do
		state=`$SSH $gdssprcol1 "ps -ef"|grep hadoop|grep -i $i|grep -v grep`
		if [ ! $? -eq 0 ]
		then
			echo "Process not running (${gdssprcol1}) : $i " >> $LOG
			echo " " >> $LOG
		fi
	done
fi


#### RUBIX monitoring #######

for rub in $gdssprrub1 $gdssprrub2
do
	tom=`$SSH $rub "ps -ef"|grep tomcat|grep -v grep|awk '{print $2}'`
	if [ ! $? -eq 0 ]
	then
		echo "Process not running (${rub}) : Tomcat" >> $LOG
		echo " " >> $LOG
	fi

	rub_status=`$SSH $rub "$CLI -t 'en' 'show pm process rubix'|grep 'Current status'|sed 's/\s//g'"|cut -d : -f2`
	if [[ "$rub_status" != "running" ]]
	then
		echo "Rubix (${rub}) : $rub_status" >> $LOG
		echo " " >> $LOG
	fi

done

##### DataNode monitoring ########

for dn in $gdssprcmp1 $gdssprcmp2 $gdssprcmp3 $gdssprcmp4 $gdssprcmp5 $gdssprcmp6 $gdssprcmp7 $gdssprcmp8 $gdssprcmp9 $gdssprcmp10
do

	dtnde=`$SSH $dn "ps -ef"|grep hadoop|grep -i datanode|grep -v grep`
	if [ ! $? -eq 0 ]
	then
		echo "Process not running (${dn}) : DataNode" >> $LOG
		echo " " >> $LOG
	fi

	dn_tt=`$SSH $dn "ps -ef"|grep hadoop|grep -i tasktracker|grep -v grep`
        if [ ! $? -eq 0 ]
        then
                echo "Process not running (${dn}) : Tasktracker" >> $LOG
		echo " " >> $LOG
        fi

done

##### INSTA monitoring ######


for insta in $gdssprins1 $gdssprins2
do

        ins_status=`$SSH $insta "$CLI -t 'en' 'show pm process insta'|grep 'Current status'|sed 's/\s//g'"|cut -d : -f2`
        if [[ "$ins_status" != "running" ]]
        then
                echo "Insta process (${insta}) : $ins_status" >> $LOG
		echo " " >> $LOG
        fi

done

for module in `$SSH $gdssprins1 "/usr/local/Calpont/bin/calpontConsole getsysteminfo" 2>/dev/null | grep ^Module 2>/dev/null | awk '{print $2";"$3}'`
do
	mod=`echo $module | awk -F ';' '{print $1}'`
	status3=`echo $module | awk -F ';' '{print $2}'`
	if [[ ! "$status3" == "ACTIVE" ]]
	then 
		echo "INSTA infinidb Status" >> $LOG
		echo "Node:$gdssprins1,insta_module:$mod,status:${status3}\n<BR>\n" >> $LOG
		echo " " >> $LOG
	fi
done


#exit;
####### RGE monitoring ########

for rge in $gdssprrge1 $gdssprrge2
do
        tom=`$SSH $rge "ps -ef"|grep tomcat|grep -v grep|awk '{print $2}'`
        if [ ! $? -eq 0 ]
        then
                echo "Process not running (${rge}) : Tomcat" >> $LOG
		echo " " >> $LOG
        fi
	
	rge_status=`$SSH $rge "$CLI -t 'en' 'show pm process rubix'|grep 'Current status'|sed 's/\s//g'"|cut -d : -f2`
	#echo "rubix status on rge node $rge :$rge_status"
        if [[ "$rge_status" != "running" ]]
        then
                echo "Rubix (${rge}) : $rge_status" >> $LOG
		echo " " >> $LOG
        fi

done
