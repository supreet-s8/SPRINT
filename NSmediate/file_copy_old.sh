#*****************************************************************************************
#Script:   file_copy.sh
#Author:   Gaurav Babbar
#Purpose:  Alternate script for NSmediate to copy files on servers
#*****************************************************************************************
script_name=$0
#********************************** usage() *********************************************
usage()
{
   echo  "Mandatory Parameters not set. Processing aborted  "
   echo  "Arguments should be more than four "
   echo  "Usage : $script_name --user= --host= --inputdirectory= --remotedirectory= --include_ip= --includestring= --excludestring=pipe separated"
   exit
}
#********************************** END usage() *********************************************


logs_dir=/data/offshore_support/NSmediate/file_copy_logs
tree=/data/offshore_support/NSmediate/tree

if [ ! -d $logs_dir/ ]
	then
	mkdir -p $logs_dir/
fi

file_check(){
	
	l_chksum=$1
	r_checksum=`ssh -q $2@$3 "md5sum $4/$5"|awk '{print $1}'`
	if [[ "$l_chksum" == "$r_checksum" ]]
		then
		return 1
	fi
}

scp_copy(){
	
	l_dir=$1
	user=$2
	host_name=$3
	r_dir=$4
	o=$5
for j in `echo "$o"`
    do
  	#echo $j	
	for i in `ls -ltr $l_dir/|grep $j|awk '{print $9}'`
	do
		#include_ip=`echo $i|cut -d'_' -f1|cut -d'.' -f1-3`
		l_chk=`md5sum $l_dir/$i|awk '{print $1}'`
		temp_file=tmp_$i
		ssh -q $user@$host_name "[ ! -d $r_dir/ ]"
		if [ $? -eq 0 ]
			then
			ssh -q $user@$host_name "mkdir -p $r_dir/"
		fi
		output_scp=`/usr/bin/scp -q $l_dir/$i $user@$host_name:$r_dir/$temp_file` 	
		if [ $? -eq 0 ]
			then
				echo "`date +'%Y%m%d %T'` TRANSFER : copying file $temp_file " >> $logs_dir/netscout.$host_name.log
				file_check $l_chk $user $host_name $r_dir $temp_file
				ret=$?
				if [ $ret -eq 1 ]
					then
					echo "`date +'%Y%m%d %T'`: SUCCESS file $temp_file copied to host $host_name with equal checksum" >> $logs_dir/netscout.$host_name.log
					#echo "`date +'%Y%m%d %T'` renaming the file $temp_file to $i  in $r_dir" >> $logs_dir/netscout.$include_ip.log
					rename=`ssh -q $user@$host_name "mv $r_dir/$temp_file $r_dir/$i" > /dev/null 2>&1`
					if [ $? -eq 0 ]
						then
						echo "`date +'%Y%m%d %T'`: SUCCESS rename of $temp_file to $i is done" >> $logs_dir/netscout.$host_name.log
						#echo "`date +'%Y%m%d %T'` removing link of the file from local " >> $logs_dir/netscout.$include_ip.log
						#rm -f $l_dir/$i
					else
						echo "`date +'%Y%m%d %T'` : FAILURE IN Renaming file..removing file $temp_file from the host" >> $logs_dir/netscout.$host_name.log
						ssh -q $user@$host_name "rm -f $r_dir/$tmp_file" > /dev/null 2>&1
					fi
					
				else
					echo "`date +'%Y%m%d %T'` : FAILURE  file $temp_file doesnot have equal checksum with the local file $i" >> $logs_dir/netscout.$host_name.log
					#echo " `date +'%Y%m%d %T'` removing file from host.." >> $logs_dir/netscout.$include_ip.log
					ssh -q $user@$host_name "rm -f $r_dir/$tmp_file" > /dev/null 2>&1 
				fi
		else
	    		echo "`date +'%Y%m%d %T'` : FAILURE File $i can not copy to host $host_name" >> $logs_dir/netscout.$host_name.log
		fi
	done
done
}


main(){

u=$1
h=$2
l_dir=$3
r_dir=$4

eval last=\${$#}

if [[ "$last" == "ip" ]]
	then
		i=$5
		out=`find $l_dir -type f -mmin +2 -mmin -8 -exec basename {} \; |grep -w $i`
		for i in `echo "$out"`
		do
			if [ -d "$tree/$h" ]
				then
					#echo "ln -s $l_dir/$i /root/tmp/$h/"
					ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
			else
				mkdir -p $tree/$h
				#echo "ln -s $l_dir/$i /root/tmp/$h/"
				ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
			fi
		done
scp_copy $tree/$h/ $user $h $r_dir "$out"

fi

if [[ "$last" == "incstring" ]]
        then
                string=$5
		out=`find $l_dir -type f -mmin +2 -mmin -8 -exec basename {} \; |egrep  $string`
                for i in `echo "$out"`
                do
                        if [ -d "$tree/$h" ]
                                then
                                        ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
				#	echo "ln -s $l_dir/$i /root/tmp/$h/"
                        else
                                mkdir -p $tree/$h
                                ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
				#echo "ln -s $l_dir/$i /root/tmp/$h/"
                        fi
                done
scp_copy $tree/$h/ $user $h $r_dir "$out"

fi


if [[ "$last" == "all" ]]
        then
		inp=$5
                in_string=$6 
		ex_string=$7
		#echo "hello $l_dir $inp"
		out=`find $l_dir -type f -mmin +2 -mmin -8 -exec basename {} \; | egrep -w "$inp" | egrep "$in_string" | egrep -vw "$ex_string"`
                for i in `echo "$out"`
                do	
                        if [ -d "$tree/$h" ]
                                then
                                        ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
				#	echo "ln -s $l_dir/$i /root/tmp/$h/"
                        else
                                mkdir -p $tree/$h
                                ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
				#echo "ln -s $l_dir/$i /root/tmp/$h/"
                        fi

                done
scp_copy $tree/$h/ $user $h $r_dir "$out"
fi


if [[ "$last" == "ipstring" ]]
        then
                i=$5
                in_string=$6
		out=`find $l_dir -type f -mmin +2 -mmin -8 -exec basename {} \; |egrep -w "$i" | egrep "$in_string"`
                for i in `echo "$out"`
                do      
                        if [ -d "$tree/$h" ]
                                then
                                        ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
					#echo "ln -s $l_dir/$i /root/tmp/$h/"
                        else
                                mkdir -p $tree/$h
                                ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
				#echo "ln -s $l_dir/$i /root/tmp/$h/"
                        fi
                        
                done
scp_copy $tree/$h/ $user $h $r_dir "$out"
fi

if [[ "$last" == "onlystring" ]]
        then
                
                in_string=$5
		ex_string=$6
		out=`find $l_dir -type f -mmin +2 -mmin -8 -exec basename {} \; | egrep "$in_string" | egrep -vw "$ex_string"`
                for i in `echo "$out"`
                do
		
                        if [ -d "$tree/$h" ]
                                then
                                        ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
					#echo "ln -s $l_dir/$i /root/tmp/$h/"
                        else
                                mkdir -p $tree/$h
                                ln -s $l_dir/$i $tree/$h/ > /dev/null 2>&1
					#echo "ln -s $l_dir/$i /root/tmp/$h/"
                        fi

                done
scp_copy $tree/$h/ $user $h $r_dir "$out"
fi

}


#user=$1
#host=$2
#input_dir=$3
#remote_dir=$4
all_arg="$*"
user=`echo $all_arg|awk '{print $1}'|cut -d'=' -f2`
host=`echo $all_arg|awk '{print $2}'|cut -d'=' -f2`
input_dir=`echo $all_arg|awk '{print $3}'|cut -d'=' -f2`
remote_dir=`echo $all_arg|awk '{print $4}'|cut -d'=' -f2`
#echo $user $host $input_dir $remote_dir
if [ $# -gt 4 ]
	then
		if [ $# -eq 5 ]
			then
				if [ `echo $5|grep -w includeip` ] 
					then
						include_ip=`echo $all_arg|awk '{print $5}'|cut -d'=' -f2`
						#echo $include_ip
						main $user $host $input_dir $remote_dir $include_ip ip 
				else
					include_string=`echo $all_arg|awk '{print $5}'|cut -d'=' -f2`
					main $user $host $input_dir $remote_dir $include_string incstring
				fi
		else
			if [ $# -eq 7 ]
				then	
					include_ip=`echo $all_arg|awk '{print $5}'|cut -d'=' -f2`
					include_string=`echo $all_arg|awk '{print $6}'|cut -d'=' -f2`
					exclude_string=`echo $all_arg|awk '{print $7}'|cut -d'=' -f2`
					main $user $host $input_dir $remote_dir $include_ip $include_string $exclude_string all
			else
				if [ `echo $5|grep -w includeip` ]
					then
						include_ip=`echo $all_arg|awk '{print $5}'|cut -d'=' -f2`
						include_string=`echo $all_arg|awk '{print $6}'|cut -d'=' -f2`
						main $user $host $input_dir $remote_dir $include_ip $include_string ipstring
				else
					include_string=`echo $all_arg|awk '{print $5}'|cut -d'=' -f2`
					exclude_string=`echo $all_arg|awk '{print $6}'|cut -d'=' -f2`
					main $user $host $input_dir $remote_dir $include_string $exclude_string onlystring
				fi
			fi
		fi
		
else
	usage
fi
