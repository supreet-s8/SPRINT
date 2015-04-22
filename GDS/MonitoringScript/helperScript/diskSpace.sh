#!/bin/sh

echo "System df -kh used if more than 80%"
echo " "

for i in 4 5 6 7 10 11 12 13 14 15 16 17 18 19 20 21 22 23 

do
       
	dsp=`ssh -q root@10.23.80.$i "df -kh" | awk -F ' ' '{if (int(\$5)>=80) print \$0}'`
	if [ "$dsp" ]
	then 
		echo " "
		echo "10.23.80.$i - FAIL"
                echo "$dsp"
		
		else
		echo " " 
		echo "10.23.80.$i - PASS"
		echo " " 
	fi
done
