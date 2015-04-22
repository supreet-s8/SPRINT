#!/bin/sh


for i in 67 
do
        echo "Hadoop admin report from Master Name Node - 10.23.80.$i"
	echo "DFS USED % should be under 80% " 
        echo " "
LOG=`ssh -q root@10.23.80.$i "/opt/sas/hadoop-0.20.204.0/bin/hadoop  dfsadmin -report 2>/dev/null" | head -12| grep -i USED% |awk -F ":" '{print $2}'|sed 's/%//'|cut -d. -f1`
LOG2=`ssh -q root@10.23.80.$i "/opt/sas/hadoop-0.20.204.0/bin/hadoop dfsadmin -report 2>/dev/null" | head -12| grep -i "Missing blocks:" |awk -F ":" '{print $2}'`
if [[ "$LOG" -gt '80' ]]
then
echo "DFS USED% : FAIL $LOG%"
else
echo "DFS USED% : PASS"
fi

if [[ "$LOG2" -eq '0' ]]
then
echo "MISSING Blocks : PASS"
else
echo "MISSING Blocks : FAIL, $LOG2"
fi



ssh -q root@10.23.80.$i "/opt/sas/hadoop-0.20.204.0/bin/hadoop  dfsadmin -report 2>/dev/null" | grep -i -A 420 'Missing blocks:' | grep -iE 'Datanodes available|Name|Decommission Status|DFS Used%' | sed 1d | awk 'ORS=NR%3?" ":"\n"'|sort > tmp.txt
#echo "$DATA"
while read line
do
j=`echo $line|awk -F: '{print $NF}'|sed 's/%//'|cut -d. -f1`
k=`echo $line|awk -F: '{print $4}'`

if [[ "$k" =~ Normal ]] && [[ "$j" -lt '80' ]]
#if [[ $k =~ Normal ]]
then
	OUT=`echo $line|awk -F: '{print $1 " " $2}'`
	#OUT=`echo $line| sort'
	echo "$OUT PASS"	
else
	echo "$line, FAIL"
fi 
done<tmp.txt


rm -rf tmp.txt

echo " "
	out=`ssh -q root@10.23.80.$i "/opt/sas/hadoop-0.20.204.0/bin/hadoop fsck / 2>/dev/null" | grep -i healthy`
	if [ $? -eq 0 ]
	then 
		echo "Hadoop FSCK report : HEALTHY "
	else

		echo "Hadoop FSCK report : NOT HEALTHY "
	fi
done

	echo " "
