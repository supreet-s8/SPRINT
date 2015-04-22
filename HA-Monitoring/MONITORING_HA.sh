#USAGE ./MONITORING_HA.sh 10.23.80.70,10.23.84.70=10.23.80.4,10.23.84.68

#!/bin/sh

stop_jobs(){


echo "MASTER IP FROM VIP IS NOT SAME AS THE CONSTANT MASTER IP PASSED FROM THE COMMAND LINE";
#
##########
## Mail notification in case of HA.
##########
#
#echo "WARNING: COLLECTOR NODE HA OBSERVED : NEW MASTER : ${MASTER_IP}" | mail -s "COLLECTOR NODE HA OBSERVED" -r production-admin@guavus.com jatin.gupta@guavus.com Jatinder.Singh@guavus.com Samuel.Joseph@guavus.com Supreet.Singh@guavus.com Gaurav.Babbar@guavus.com

if [ $? == '0' ]
then

echo "Notification Send...";

else

echo "Some problem with Notification";

fi

##########
## Stopping all jobs on MASTER and SLAVE both.
##########

for IP in $MASTER_IP $SLAVE_IP
do

#echo "Step 1. Terminating Collector on $IP";
#ssh -q root@$IP "/opt/tms/bin/cli -t 'en' 'conf t' 'pm process collector terminate'"
#
#echo "Step 2. Disabling AUTO LAUNCH on $IP";
#ssh -q root@$IP "/opt/tms/bin/cli -t 'en' 'conf t' 'no pm process collector launch auto'"
#ssh -q root@$IP "/opt/tms/bin/cli -t 'en' 'conf t' 'no pm process collector launch relaunch auto'"
#ssh -q root@$IP "/opt/tms/bin/cli -t 'en' 'conf t' 'write mem'"
#
#echo "Step 3. Show COLLECTOR STATUS on $IP";
ssh -q root@$10.23.80.11 "/opt/tms/bin/cli -t 'en' 'conf t' 'show pm process collector'" | grep -i "current status"
#
done
#
#echo "Step 4. Terminating JOBS on MASTER IP ONLY : $MASTER_IP";
#ssh -q root@$MASTER_IP "/opt/tms/bin/pmx subshell oozie 'stop jobname all'"
#
#echo "Step 5. Checking JOB status on MASTER IP ONLY : $MASTER_IP";
#ssh -q root@$MASTER_IP "/opt/tms/bin/pmx subshell oozie show workflow RUNNING jobs"
#ssh -q root@$MASTER_IP "/opt/tms/bin/pmx subshell oozie show coordinator RUNNING jobs"
#
}

NOW=`date`;
echo "STARTING logs for $NOW";

for TOKEN in $*
do
#########
# Extracting VIP's for NAE and CA both from the Command Line.
#########
echo $TOKEN

if echo ${TOKEN} | cut -d "=" -f1  | grep -q ","; then 
#########
# VIP in case of NAE.
#########
echo "For NAE";
VIP_1=`echo $TOKEN | cut -d "=" -f1 | cut -d "," -f1`;
VIP_2=`echo $TOKEN | cut -d "=" -f1 | cut -d "," -f2`;
echo $VIP_1
echo $VIP_2
#########
# Checking for the availability of the VIPS in the network.
#########

ping -c 1 $VIP_1 > /dev/null;

if [ $? == '0' ]
then

VIP=$VIP_1;
echo $VIP
else
VIP=$VIP_2;
echo $VIP
fi

#########
# Extracting CONSTANT MASTER IP's from the Command Line.
#########

CONSTANT_MASTER_IP_1=`echo $TOKEN | cut -d "=" -f2 | cut -d "," -f1`;
CONSTANT_MASTER_IP_2=`echo $TOKEN | cut -d "=" -f2 | cut -d "," -f2`;
echo $CONSTANT_MASTER_IP_1
echo $CONSTANT_MASTER_IP_2

MASTER_IP=`ssh -q root@$VIP "/opt/tms/bin/cli -t 'en' 'conf t' 'sh cluster global brief' | grep -i master|tail -1"|awk '{print $NF}'`;
SLAVE_IP=`ssh -q root@$VIP "/opt/tms/bin/cli -t 'en' 'conf t' 'sh cluster global brief' | grep -i standby|tail -1"|awk '{print $NF}'`;
echo $MASTER_IP
echo $SLAVE_IP

#########
# Check for NULL Master AND SLAVE IP  if null then exit from the script.
#########

echo $MASTER_IP , $SLAVE_IP;
echo "testing"
if [[ $MASTER_IP != $CONSTANT_MASTER_IP_1 && $MASTER_IP != $CONSTANT_MASTER_IP_2 ]]
then
#echo "MASTER IP - $MASTER_IP FROM VIP($VIP) IS NOT SAME AS THE CONSTANT MASTER IP - $CONSTANT_MASTER_IP_1 or $CONSTANT_MASTER_IP_2 PASSED FROM THE COMMAND LINE";
echo "MASTER IP - $MASTER_IP FROM VIP ($VIP) IS NOT SAME AS THE CONSTANT MASTER IP's - $CONSTANT_MASTER_IP_1 or $CONSTANT_MASTER_IP_2 PASSED FROM THE COMMAND LINE. Please look into this ASAP"  | mail -s "NAMENODE NODE HA ALERT" -r Sprint_production-admin@guavus.com noc.support@guavus.com Jatinder.Singh@guavus.com Samuel.Joseph@guavus.com Eric.Darby@guavus.com Kevin.Keschinger@guavus.com Robert.Phillips@guavus.com  mohsin.ali@guavus.com
#stop_jobs
else
echo "MASTER IP $MASTER_IP FROM VIP($VIP) IS SAME AS THE CONSTANT MASTER IP $CONSTANT_MASTER_IP_1,$CONSTANT_MASTER_IP_2 PASSED FROM THE COMMAND LINE";

fi

else

#########
# VIP in case of CA.
#########

echo "For CA";
#VIP=`echo $TOKEN | cut -d "=" -f1`;

#MASTER_IP=`ssh -q root@$VIP "/opt/tms/bin/cli -t 'en' 'conf t' 'sh cluster global brief' | grep -i master|tail -1"|awk '{print $NF}'`;
#SLAVE_IP=`ssh -q root@$VIP "/opt/tms/bin/cli -t 'en' 'conf t' 'sh cluster global brief' | grep -i standby|tail -1"|awk '{print $NF}'`;

#echo $MASTER_IP , $SLAVE_IP;
#CONSTANT_MASTER_IP=`echo $TOKEN | cut -d "=" -f2`;

#if [ $MASTER_IP != $CONSTANT_MASTER_IP ]
#then
#echo "MASTER IP $MASTER_IP FROM VIP($VIP) IS NOT SAME AS THE CONSTANT MASTER IP $CONSTANT_MASTER_IP PASSED FROM THE COMMAND LINE";
#echo "MASTER IP $MASTER_IP FROM VIP ($VIP) IS NOT SAME AS THE CONSTANT MASTER IP $CONSTANT_MASTER_IP PASSED FROM THE COMMAND LINE" | mail -s "COLLECTOR NODE HA OBSERVED" -r production-admin@guavus.com jatin.gupta@guavus.com Jatinder.Singh@guavus.com Samuel.Joseph@guavus.com Supreet.Singh@guavus.com Gaurav.Babbar@guavus.com Kevin.Keschinger@guavus.com Robert.Phillips@guavus.com Vince.Stockdale@guavus.com
#stop_jobs
#else
#echo "MASTER IP $MASTER_IP FROM VIP($VIP) IS SAME AS THE CONSTANT MASTER IP $CONSTANT_MASTER_IP  PASSED FROM THE COMMAND LINE";
#fi

fi

done

echo "ENDING logs for $NOW";


