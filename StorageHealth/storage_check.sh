#!/bin/sh

path=/data/offshore_support/StorageHealth/

script=$0

if [ -f ${path}error.log ]
then
	rm -f ${path}error.log
fi


### function to check transfer and received bytes  ####

function checktraffic
{
remote=$1

#for i in `ssh -q root@${remote} "ifconfig" | grep -B 1 -E  "10.23.82|10.23.83"|grep eth |awk '{print $1}'`
#do	
#ssh root$@{remote} "ifconfig $i"|grep -E 'TX|RX'|grep  packets|awk '{print $2}'|cut -d':' -f2 > file1
#done

eth1=`ssh -q root@${remote} "ifconfig" | grep -B 1 "10.23.82"|grep eth |awk '{print $1}'`
eth2=`ssh -q root@${remote} "ifconfig" | grep -B 1 "10.23.83"|grep eth |awk '{print $1}'`

ssh -q root@${remote} "ifconfig $eth1"| grep -E 'TX|RX'|grep  packets|awk '{print $2}'|cut -d':' -f2 > ${path}tmp1_eth1.txt
sleep 10
ssh -q root@${remote} "ifconfig $eth1"| grep -E 'TX|RX'|grep  packets|awk '{print $2}'|cut -d':' -f2 > ${path}tmp2_eth1.txt

ssh -q root@${remote} "ifconfig $eth2"| grep -E 'TX|RX'|grep  packets|awk '{print $2}'|cut -d':' -f2 > ${path}tmp1_eth2.txt
sleep 10
ssh -q root@${remote} "ifconfig $eth2"| grep -E 'TX|RX'|grep  packets|awk '{print $2}'|cut -d':' -f2 > ${path}tmp2_eth2.txt


diff1=`diff ${path}tmp1_eth1.txt ${path}tmp2_eth1.txt`
diff2=`diff ${path}tmp1_eth2.txt ${path}tmp2_eth2.txt`

if [[ ! $diff1 ]] && [[ ! $diff2 ]]
then
	return 1
else
	return 0
fi

}


#### function to check for insta #####

function instacheck
{

ip=$1

role=`ssh -q root@${ip} "/opt/tms/bin/cli -t 'en' 'conf t' 'show cluster local'"|grep "Node Role"|sed 's/\s//g'|awk -F : '{print $NF}'`

if [[ $role == master ]]
then

	out=`ssh -q root@${ip} "mount" | grep "/dev/mapper" | grep -w "rw"`
	#echo "$ip $out"
	if [[ $out ]]
	then
		### will check for other server, skipping everything for the current server
		continue
	
	else
		
		#echo "$ip is not in read/write mode" >> ${path}error.log  
	
		##### check for iscsi and multipath services	
	
		service_iscsi=`ssh -q root@${ip} "/sbin/service iscsi status"|grep running`
		mul_path=`ssh -q root@${ip} "/sbin/multipath -ll"|grep status|grep active|wc -l`
		m_path=`ssh -q root@${ip} "/sbin/multipath -ll"|grep status|grep active`
		if [[ ! $service_iscsi ]] 	## iscsi service is not running, check for other server
		then
			echo "$ip is not in read/write mode" >> ${path}error.log
			echo "$ip : iscsi service is not running, please check asap" >> ${path}error.log
			continue
		else
			if [ $mul_path -eq 0 ] ## service iscsi is running, multipath is not showing active status
			then
				echo "$ip is not in read/write mode" >> ${path}error.log
				echo "$ip : iscsi service is running, multipath is not showing active status" >> ${path}error.log
				continue
			fi
		fi

		if [[ $service_iscsi ]] && [ $mul_path -le 2 ]   ## iscsi service running and active multipath less than 2
		then
			echo "$ip is not in read/write mode" >> ${path}error.log
			echo "$ip : service iscsi is running, active multipath less than 2 , please check" >> ${path}error.log	 
			echo "present multipath: $mul_path" >> ${path}error.log
			echo "$m_path" >> ${path}error.log
			continue
		fi
		
		if [[ $service_iscsi ]] && [ $mul_path -ge 3 ] ### check for TX/RX traffic
		then
			checktraffic $ip
			result=`echo $?`
			if [ $result -eq 1 ]
			then
				echo "$ip : Transfer and Receive bytes are stuck, please check your system" >> ${path}error.log
			fi
		fi
	fi
fi

}

### main() traverse servers file

for ip in `cat ${path}servers`
do

	hstname=`ssh -q root@${ip} "hostname"`

  if [[ $hstname =~ insta ]]
  then
  	instacheck $ip
 
  else

	out=`ssh -q root@${ip} "mount" | grep "/dev/mapper" | grep -w "rw"`
	
#	echo "$ip $out"
	if [[ $out ]]
	then
		### will check for other server, skipping everything for the current server
		continue
	
	else
		
		#echo "$ip is not in read/write mode" >> ${path}error.log  
	
		##### check for iscsi and multipath services	
	
		service_iscsi=`ssh -q root@${ip} "/sbin/service iscsi status"|grep running`
		mul_path=`ssh -q root@${ip} "/sbin/multipath -ll"|grep status|grep active|wc -l`
		m_path=`ssh -q root@${ip} "/sbin/multipath -ll"|grep status|grep active`
		if [[ ! $service_iscsi ]] 	## iscsi service is not running, check for other server
		then
			echo "$ip is not in read/write mode" >> ${path}error.log
			echo "$ip : iscsi service is not running, please check asap" >> ${path}error.log
			continue
		else
			if [ $mul_path -eq 0 ] ## service iscsi is running, multipath is not showing active status
			then
				echo "$ip is not in read/write mode" >> ${path}error.log
				echo "$ip : iscsi service is running, multipath is not showing active status" >> ${path}error.log
				continue
			fi
		fi

		if [[ $service_iscsi ]] && [ $mul_path -le 2 ]   ## iscsi service running and active multipath less than 2
		then
			echo "$ip is not in read/write mode" >> ${path}error.log
			echo "$ip : service iscsi is running, active multipath less than 2 , please check" >> ${path}error.log	 
			echo "present multipath: $mul_path" >> ${path}error.log
			echo "$m_path" >> ${path}error.log
			continue
		fi
		
		if [[ $service_iscsi ]] && [ $mul_path -ge 3 ] ### check for TX/RX traffic
		then
			checktraffic $ip
			result=`echo $?`
			if [ $result -eq 1 ]
			then
				echo "$ip : Transfer and Receive bytes are stuck, please check your system" >> ${path}error.log
			fi
		fi
	fi

  fi	
done

## sending mail if there is some error exists

if [ -f ${path}error.log ]
then
	cat ${path}error.log
fi
