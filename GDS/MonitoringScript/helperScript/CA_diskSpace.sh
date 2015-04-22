#!/bin/sh

echo "Disk space used if more than 80%"
echo " "

for i in 71 72 74 75 77 78 80 81 40 41 42 43 44 46 48 49 50 53 54 55 58 59 60 61 62 63 64 66 68 92 99 100 93 94 95 96 

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
