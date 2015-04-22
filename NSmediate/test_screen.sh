#!/bin/bash

echo "===CHECKING SCREENS STATUS==="


scriptStat=`ssh -q root@10.23.80.4 "ls -lrth /var/run/screen/S-root |grep -i 'NSmediate'"|awk '{print $NF}'|wc -l`

Names_Of_Screens=`ssh -q root@10.23.80.4 "ls -lrth /var/run/screen/S-root |grep -i 'NSmediate'"|awk '{print $NF}'`

if [ $scriptStat -eq 1 ]; then

  echo "====Screen is Running===="
  echo "$Names_Of_Screens"
else
  echo "====Screen is Not Running on 10.23.80.4===="
echo "check /data/offshore_support/NSmediate/run_book.sh on 10.23.80.4" | mail -s "Screen NSmediate is not running on 10.23.80.4" -r Sprint_production.monitoring@guavus.com     noc.support@guavus.com jatinder.singh@guavus.com robert.phillips@guavus.com samuel.joseph@guavus.com eric.darby@guavus.com mohsin.ali@guavus.com
 
fi
