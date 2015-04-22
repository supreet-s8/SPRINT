#*****************************************************************************************
script_name=$0
#********************************** usage() *********************************************
usage()
{
   echo  "Mandatory Parameters not set. Processing aborted  "
   echo  "Arguments should be more than four "
   echo  "Usage : $script_name --user= --host= --inputdirectory= --remotedirectory= --includeip= --includestring= --excludestring=pipe separated"
   exit
}
#********************************** END usage() *********************************************

main(){

u=$1
h=$2
l_dir=$3
r_dir=$4

eval last=\${$#}

if [[ "$last" == "ip" ]]
	then
		i=$5
		out1=`find $l_dir -type f -mmin +2 -mmin -8 |grep -w $i|xargs -I {} du -s {} |awk '{sum+=$1}END{print sum}'`
		if [[ ! $out1 == "" ]]
		then
		echo "`date`:$h:$out1" >> Netscout_fileCount.txt
		fi
fi

if [[ "$last" == "incstring" ]]
        then
                string=$5
#find $l_dir -type f -mmin +2 -mmin -8 |egrep  $string
		out2=`find $l_dir -type f -mmin +2 -mmin -8 |egrep  $string|xargs -I {} du -s {} |awk '{sum+=$1}END{print sum}'`
		if [[ ! $out2 == "" ]]
		then
		echo "`date`:$h:$out2" >> Netscout_fileCount.txt
fi
fi

if [[ "$last" == "excstring" ]]
        then
                string=$5
#find $l_dir -type f -mmin +2 -mmin -8  |egrep -v $string
                out3=`find $l_dir -type f -mmin +2 -mmin -8  |egrep -v $string|xargs -I {} du -s {} |awk '{sum+=$1}END{print sum}'`
		if [[ ! $out3 == "" ]]
		then
		echo "`date`:$h:$out3" >> Netscout_fileCount.txt

fi
fi
if [[ "$last" == "all" ]]
        then
		inp=$5
                in_string=$6 
		ex_string=$7
		#echo "hello $l_dir $inp"
#find $l_dir -type f -mmin +2 -mmin -8 | egrep -w "$inp" | egrep "$in_string" | egrep -v "$ex_string"
		out4=`find $l_dir -type f -mmin +2 -mmin -8 | egrep -w "$inp" | egrep "$in_string" | egrep -v "$ex_string"|xargs -I {} du -s {} |awk '{sum+=$1}END{print sum}'`
		if [[ ! $out4 == "" ]]
		then
		echo "`date`:$h:$out4" >> Netscout_fileCount.txt
fi
fi


if [[ "$last" == "ipstring" ]]
        then
                i=$5
                in_string=$6
#find $l_dir -type f -mmin +2 -mmin -8 |egrep  "$i" | egrep "$in_string"
		out5=`find $l_dir -type f -mmin +2 -mmin -8 |egrep  "$i" | egrep "$in_string"|xargs -I {} du -s {} |awk '{sum+=$1}END{print sum}'`
		if [[ ! $out5 == "" ]]
		then
		echo "`date`:$h:$out5" >> Netscout_fileCount.txt
fi
fi
if [[ "$last" == "ipexcstring" ]]
        then
                i=$5
                in_string=$6
#find $l_dir -type f -mmin +2 -mmin -8  |egrep -w "$i" | egrep -v "$in_string"
	  
              out6=`find $l_dir -type f -mmin +2 -mmin -8  |egrep -w "$i" | egrep -v "$in_string"|xargs -I {} du -s {} |awk '{sum+=$1}END{print sum}'`
		if [[ ! $out6 == "" ]]
		then	
	echo "`date`:$h:$out6" >> Netscout_fileCount.txt
fi
fi



if [[ "$last" == "onlystring" ]]
        then
                
                in_string=$5
		ex_string=$6
#find $l_dir -type f -mmin +2 -mmin -8 | egrep "$in_string" | egrep -v "$ex_string"
		out7=`find $l_dir -type f -mmin +2 -mmin -8 | egrep "$in_string" | egrep -v "$ex_string"|xargs -I {} du -s {} |awk '{sum+=$1}END{print sum}'`
		if [[ ! $out7 == "" ]]
		then
		echo "`date`:$h:$out7" >> Netscout_fileCount.txt
fi
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
					if [ `echo $5|grep -w includestring` ]
						then
							include_string=`echo $all_arg|awk '{print $5}'|cut -d'=' -f2`
							main $user $host $input_dir $remote_dir $include_string incstring
					else
						exclude_string=`echo $all_arg|awk '{print $5}'|cut -d'=' -f2`
						main $user $host $input_dir $remote_dir $exclude_string excstring     
					fi
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
					if [ `echo $6|grep -w includestring` ]
						then
							include_string=`echo $all_arg|awk '{print $6}'|cut -d'=' -f2`
							main $user $host $input_dir $remote_dir $include_ip $include_string ipstring
					else 
						exclude_string=`echo $all_arg|awk '{print $6}'|cut -d'=' -f2`
						main $user $host $input_dir $remote_dir $include_ip $exclude_string ipexcstring        
					fi
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
