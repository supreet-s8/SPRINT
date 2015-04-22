#!/bin/bash
#source /var/home/root/.bash_profile

path=/data/offshore_support/nodata_trap

check=`ssh -q root@10.23.80.11 "/opt/tms/bin/cli -m config -t 'show pm process collector'" | grep status | awk -F: '{print $NF}'`
sleep 1
workflow=`/opt/tps/bin/pmx.py subshell oozie show workflow RUNNING jobs |grep -w DataTransfer`
sleep 1
coordinator=`/opt/tps/bin/pmx.py subshell oozie show coordinator RUNNING jobs |grep -w DataTransfer`

if [ -f ${path}/tmp.txt ]
then
	rm -f ${path}/tmp.txt
fi

function addpator_check
{
	sprpath=$1
	collpath=$2
	error_file=$3
	adaptor=$4
	spr_file=`ls $sprpath|wc -l`
	coll_file=`ssh -q root@10.23.80.11 "ls $collpath"|wc -l`

## job is running,sprint and collector paths contain files and error files equal or  more than 0

	if [[ $workflow ]] || [[ $coordinator ]] && [ $spr_file -gt 0 ] && [ $coll_file -gt 0 ] && [ $error_file -gt 0 ] 
	then
		nofp=`ssh -q root@10.23.80.11 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $adaptor num-files-processed interval-type 1-hour'"|tail -1|awk '{print $NF}'`
		echo "`date` $adaptor : number of files processed : ${nofp}, number of files with error : ${error_file}, Please verify error files on collector" >> ${path}/tmp.txt
	fi

## job is running,sprint and collector paths contain zero file

	if [[ $workflow ]] || [[ $coordinator ]] && [ $spr_file -eq 0 ] && [ $coll_file -eq 0 ]
	then
		echo "`date` $adaptor : both sprint and collector paths are empty" >> ${path}/tmp.txt
	fi

## job is not runnning

	if [[ ! $workflow ]] &&  [[ ! $coordinator ]]
	then
		if [ $spr_file -gt 0 ] && [ $coll_file -eq 0 ] ## sprint path contains files, collector path zero files
		then
			echo "`date` $adaptor : DataTransfer job is not running but sprint path has data" >> ${path}/tmp.txt
		else
			echo "`date` $adaptor : DataTransfer job is not running,file count on sprint $spr_file on collector $coll_file" >> ${path}/tmp.txt
		fi
	else
		if [ $spr_file -ge 0 ] && [ $coll_file -eq 0 ]
		then
			echo "`date` $adaptor : job is in coordinator, file count on sprint is $spr_file and on collector file count is $coll_file" >> ${path}/tmp.txt
		fi
	fi

##number of files processed
## job is running,sprint path zero files and collector paths contains files and error files equal or  more than 0

	if [[ $workflow ]] || [[ $coordinator ]] && [ $spr_file -eq 0 ] && [ $coll_file -gt 0 ] && [ $error_file -ge 0 ]
	then
		nofp=`ssh -q root@10.23.80.11 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $adaptor num-files-processed interval-type 1-hour'"|tail -1|awk '{print $NF}'`
		echo "`date` $adaptor : zero file in sprint directory, number of files processed for the current hour is $nofp" >> ${path}/tmp.txt
	fi

}
function dataTrap
{
	adaptor=$1
	ef=$2

	case $adaptor in

		cdmaIpdr) addpator_check /data/feeds/IPDR /data/feeds/collector/ipdr $ef cdmaIpdr ;;
		wimax) addpator_check /data/feeds/WIMAX /data/feeds/collector/wimax $ef wimax ;;
		lteIpdr) addpator_check /data/feeds/LTE /data/feeds/collector/lte $ef lteIpdr ;;
		cdmaVoice) addpator_check /data/feeds/CDR /data/feeds/collector/voice $ef cdmaVoice ;;
		*) exit ;;
	esac
}
if [ $check == running ]
then
        for i in cdmaIpdr wimax lteIpdr cdmaVoice
        do
		tf=`ssh -q root@10.23.80.11 "/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $i total-flow interval-type 1-hour'"|tail -1|awk '{print $NF}'`
		 #df=`/opt/tms/bin/cli -m config -t 'collector stats instance-id 1 adaptor-stats $i dropped-flow interval-type 1-hour'"|tail -1|awk '{print $NF}'`
		nofpe=`ssh -q root@10.23.80.11 "/opt/tms/bin/cli -t 'en' 'conf t' 'collector stats instance-id 1 adaptor-stats $i num-files-with-errors interval-type 1-hour'"|tail -1|awk '{print $NF}'`
#	echo "$i : $tf $nofpe"
## col job sprint pathrunning
		if [ $tf -eq 0 ]
		then
			dataTrap $i $nofpe
		fi
	done

else
	#echo "collector not running" > ${path}/tmp.txt
	exit

fi

if [ -f ${path}/tmp.txt ]
then
#cat ${path}/tmp.txt
	ssh root@10.23.80.24 "echo '`cat ${path}/tmp.txt`' |mail -s 'NoDataTrap' -r sprint.production.monitoring@guavus.com gaurav.babbar@guavus.com jatinder.singh@guavus.com samuel.joseph@guavus.com manish.sharma@guavus.com eric.darby@guavus.com mohsin.ali@guavus.com robert.phillips@guavus.com shailendra.kumar@guavus.com noc.support@guavus.com"
fi
