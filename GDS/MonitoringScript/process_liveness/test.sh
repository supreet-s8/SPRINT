#!/bin/bash

PATH="/data/jboss/jboss_4.0.3sp1//bin:/opt/hadoop/bin/:/usr/local/bin:/opt/tms/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11R6/bin:/var/home/root/bin"
export PATH
source /data/GDS/MonitoringScript/process_liveness/env
echo $SSH
echo $gdssprrge1
echo $CLI
LOG="/data/GDS/MonitoringScript/process_liveness/log.txt"
$SSH $gdssprrge1 "$CLI -t 'en' 'show pm process rubix'|grep 'Current status'|sed 's/\s//g'|tr [A-Z] [a-z]" |cut -d":" -f2 > $LOG
