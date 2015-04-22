#!/bin/sh

DATA=`ssh -q root@10.23.80.70 "/bin/df -kh "|grep -w /data$ |awk '{print $(NF-1)}'|sed 's/%//g'`
DATA1=`ssh -q root@10.23.80.70 "/bin/df -kh "|grep -w /data/feeds$ |awk '{print $(NF-1)}'|sed 's/%//g'`
DATA2=`ssh -q root@10.23.80.11 "/bin/df -kh "|grep -w /data$ |awk '{print $(NF-1)}'|sed 's/%//g'`
DATA3=`ssh -q root@10.23.80.11 "/bin/df -kh "|grep -w /data/feeds$ |awk '{print $(NF-1)}'|sed 's/%//g'`
if [[ "$DATA" -gt 80 ]]


then

echo "Local /data Disk Size is above limits : ${DATA}%" |mail -s " SprintWirelessLocal Disk on 10.23.80.70" -r sprint.production.monitoring@guavus.com noc.support@guavus.com jatinder.singh@guavus.com samuel.joseph@guavus.com eric.darby@guavus.com mohsin.ali@guavus.com robert.phillips@guavus.com 



elif [[ "$DATA1" -gt 80 ]]

then

echo " /data/feeds Disk Size is above limits : ${DATA1}%" |mail -s "SprintWireless Local Disk on 10.23.80.70" -r sprint.production.monitoring@guavus.com noc.support@guavus.com jatinder.singh@guavus.com samuel.joseph@guavus.com eric.darby@guavus.com mohsin.ali@guavus.com robert.phillips@guavus.com  

elif [[ "$DATA2" -gt 80 ]]

then

echo " /data Disk Size is above limits : ${DATA2}%" |mail -s "SprintWireless Local Disk on 10.23.80.11" -r sprint.production.monitoring@guavus.com jatinder.singh@guavus.com samuel.joseph@guavus.com noc.support@guavus.com eric.darby@guavus.com mohsin.ali@guavus.com robert.phillips@guavus.com

elif [[ "$DATA3" -gt 80 ]]

then

echo " /data/feeds Disk Size is above limits : ${DATA3}%" |mail -s "SprintWireless Local Disk on 10.23.80.11" -r sprint.production.monitoring@guavus.com jatinder.singh@guavus.com samuel.joseph@guavus.com noc.support@guavus.com eric.darby@guavus.com mohsin.ali@guavus.com robert.phillips@guavus.com



fi


