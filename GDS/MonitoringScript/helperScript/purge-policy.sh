#!/bin/sh
DATE=`date --date='7 day ago' '+%Y/%m/%d'`
PATH=`cut -d '/' -f3,4,5 purge-policy`
for i in `/bin/cat purge-policy` 
	do
		echo "******$i******"
		/opt/hadoop/bin/hadoop dfs -lsr $i$DATE | /usr/bin/awk '{sum+$5}END{print sum/1024/1024/1024}'
		echo " "

done
