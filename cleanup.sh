#*****************************************************************************************
#Script:   cleanup.sh
#Author:   Gaurav Babbar
#Purpose:  Cleanup of files day wise
#*****************************************************************************************

script_name=$0
config=$1
$ip=$2
usage()
{
   echo  "Mandatory Parameters not set. Processing aborted  "
   echo  "configuration file or  ip missing "
   echo  "Usage : $script_name <configuration file> <ip>"
   exit
}
#********************************** END usage() *********************************************

if [ $# -lt 2 ]
	then
		usage
fi
check(){

d_diff=$1
directory=$2
tme_old=`ssh -q -n root@$ip /opt/hadoop/bin/hadoop dfs -lsr $directory|grep DONE|head -1|awk '{print $8}'|awk -F "/" 'BEGIN { OFS = "-" } {print $(NF-4),$(NF-3),$(NF-2)}'`
epc_old_file=`date +%s -d "$tme_old"`
echo "in check function $epc_old_file"
if [[ "$epc_old_file" -lt "$d_diff" ]]
	then
                  strt_time=`date +'%Y/%m/%d' -d@$epc_old_file`
                  stop_time=`date +'%Y/%m/%d' -d@$day_diff`
                  echo "starting dir is $dir$strt_time"
                  echo "stopping time is $dir$stop_time"
		  out=`ssh -q -n root@$ip /opt/hadoop/bin/hadoop dfs -rmr $dir$strt_time`
		  check $d_diff $directory
	else
		return
fi

}

for i in `cat $config`
	do
		dir=`echo $i|cut -d':' -f1`
		day=`echo $i|cut -d':' -f2`
		day_epc=`expr $day \* 60 \* 60 \* 24`
		file_latest=`ssh -q -n root@$ip /opt/hadoop/bin/hadoop dfs -lsr $dir|grep DONE|tail -1|awk '{print $8}'`
		#tme_old=`hadoop dfs -lsr /tools/output/wimax/|grep DONE|head -1|awk '{print $8}'|awk -F "/" 'BEGIN { OFS = "-" } {print $(NF-4),$(NF-3),$(NF-2)}'`
		tme_latest=`ssh -q -n root@$ip /opt/hadoop/bin/hadoop dfs -lsr $dir|grep DONE|tail -1|awk '{print $8}'|awk -F "/" 'BEGIN { OFS = "-" } {print $(NF-4),$(NF-3),$(NF-2)}'`

		#echo "time of old file $tme_old"
		#epc_old_file=`date +%s -d "$tme_old"`
		epc_latest_file=`ssh -q -n root@$ip date +%s -d "$tme_latest"`
		#echo "latest epoc $epc_latest_file old file epc  $epc_old_file"	
		day_diff=`expr $epc_latest_file - $day_epc`
		#echo "difference $day_diff"
		check $day_diff $dir
		
done
