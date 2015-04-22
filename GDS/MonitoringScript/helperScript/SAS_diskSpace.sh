#!/bin/sh

echo "Disk space used if more than 80%"
echo " "

for i in 67 69 90 91 39 45 

do
       
	dsp=`ssh -q root@10.23.80.$i "df -kh" | awk -F ' ' '{if (int(\$5)>=80) print \$0}'`
	if [ "$dsp" ]
	then 
		echo " "
		echo "10.23.80.$i - FAIL"
                echo "$dsp"
		
		else
		echo " "
		echo "10.23.80.$i - PASS";
		echo " "
	fi
done
