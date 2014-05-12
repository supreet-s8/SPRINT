#*****************************************************************************************
#Script:   cdr_wrapper.sh
#Author:   Gaurav Babbar
#Purpose:  Super CDR report
#*****************************************************************************************

script_name=$0
config=$1
ip=$2
oozie_dir=/data/oozie-admi
usage()
{
   echo  "Mandatory Parameters not set. Processing aborted  "
   echo  "configuration file or ip is missing "
   echo  "Usage : $script_name configuration_file ip"
   exit
}
#********************************** END usage() *********************************************

if [ $# -lt 2 ]
        then
                usage
fi

dte=`ssh -q root@$ip date +'%Y-%m-%d'`
dt1=`ssh -q root@$ip date +'%Y-%m-%dT%H:%M:%S'`
if [ $? -ne 0 ]
	then    
        	echo "problem with ssh please check" 
fi

while read line
	do
		job=`echo $line|cut -d':' -f1`
		action=`echo $line|cut -d':' -f2`
		counters=`echo $line|cut -d':' -f3`
		group=`echo $line|cut -d':' -f4`
		file_date=`ssh -q -n root@$ip /opt/oozie/bin/oozie jobs -oozie http://$ip:8080/oozie -jobtype wf 2>/dev/null | grep $job | grep SUCCEEDED |head -1|awk '{print $6}'`
		dt1=`ssh -q -n root@$ip /opt/tms/bin/pmx subshell oozie show workflow SUCCEEDED jobs| grep $job  | awk '{print $8,$9}'`
		if [ $? -ne 0 ]
			then
				echo "problem with ssh please check"
		fi	
		if [[ "$dte" != "$file_date" ]]
			then
				dir=`ssh -q -n root@$ip /opt/oozie/bin/oozie jobs -oozie http://$ip:8080/oozie -jobtype wf 2>/dev/null |grep $job| grep SUCCEEDED |head -1|awk '{print $1}'`
                		if [ $? -ne 0 ]
                        		then    
                                		echo "problem with ssh please check" 
               			 fi				
				#echo $dir
				job=`ssh -q -n root@$ip "cd $oozie_dir/$dir ; grep  -ri 'running job' * |grep -i '$action'"`
                                if [ $? -ne 0 ] 
                                        then
                                                echo "problem with ssh please check"  
                                fi				
				job_id=`echo $job|awk '{print $NF}'`
				OLDIFS=$IFS
				IFS=$','
				for j in $counters
					do
						for k in $group
							do
								#echo "ssh -q -n root@$ip /opt/hadoop/bin/hadoop job -counter $job_id '$k' '$j'"
								value=`ssh -q -n root@$ip "/opt/hadoop/bin/hadoop job -counter $job_id '$k' '$j'"`
								if [ $? -ne 0 ]
  								      then
                								echo "problem with ssh please check"
								fi
								l=`echo $j|sed 's/ /\_/g'`
								echo "$k,$j,$value,$dt1" >> logs_$l.csv
						done
				done
			else
				echo "Date of the job does not of the current date: current date = $dte job date = $file_date "
		
		fi
IFS=$OLDIFS
done < $config
