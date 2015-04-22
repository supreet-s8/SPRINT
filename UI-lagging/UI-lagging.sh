#!/bin/sh 
#------------------------------------#
######## CHECKING UI  STATUS #########
#------------------------------------#

ssh -q root@10.23.80.4 "sh /data/offshore_support/UI-Lag.sh" >/data/offshore_support/UI-lagging/UI.log

	if [  -s  /data/offshore_support/UI-lagging/UI.log ]
	then
		echo "`ssh -q root@10.23.80.4 "sh /data/offshore_support/UI-Lag.sh"`" |mail -s "Sprint wireless UI LAG Status" -r sprint.production.monitoring@guavus.com  noc.support@guavus.com jatinder.singh@guavus.com  gds-india@guavus.com  eric.darby@guavus.com mohsin.ali@guavus.com robert.phillips@guavus.com kevin.keschinger@guavus.com
	fi

#-----------------------------------------------#
######## CHECKING SEGMENT FILES LAG #############
#-----------------------------------------------#

segment=`ssh -q  root@10.23.80.4 "perl /data/SamJ/KPI-scripts/segmentFileCK.pl"`
check="Current segment feed up to date"

	if [[ "${segment}" == "${check}" ]]
	then
                exit
	else

                echo "`ssh root@10.23.80.4 "perl /data/SamJ/KPI-scripts/segmentFileCK.pl"`" |mail -s 'Segment Files ' -r  sprint.production.monitoring@guavus.com noc.support@guavus.com jatinder.singh@guavus.com mohsin.ali@guavus.com samuel.joseph@guavus.com  noc.support@guavus.com

	fi

