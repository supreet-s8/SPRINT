#!/bin/bash

#To pass argument whith script use as following: messageFileName='messages.1.gz' ./dropCount.sh
#To read input values use as following:
#echo "provide name of message file name, followd by [ENTER]:"
#read messageFileName


newCount=0
for i in 70

do
	echo "On collector VIP 10.23.80.$i total record drop with reason: Record too old or too in future found in messages.1.gz" 
        
	drop1=`ssh -q root@10.23.80.$i "zcat /var/log/messages.1.gz" | grep -i collector.ERR | grep -i  'Dropping: Record too old or too in future' | cut -d ',' -f 4 | awk '{sum+=\$3}END{print sum}'`
	
	echo "$drop1" 
	
	newCount=`expr $newCount + $drop1`
	
	ssh -q root@10.23.80.$i "zcat /var/log/messages.1.gz" | grep -i 'collector.ERR' | grep -i  'Dropping: Record too old or too in future'| awk -F " " '{print " " $22," "$25, " "$NF}'| cut -d ")" -f1| awk '{gsub(",total", "");print}' |awk -F ',' '{print $1 "\t" $3 "\t" $2}' | grep -v too  >>/data/SamJ/KPI-scripts/testFormate.csv

done

echo "total drop records: $newCount" 
