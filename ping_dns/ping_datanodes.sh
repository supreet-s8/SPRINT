#Enter timer value in seconds
exec 1> /data/GDS/ping_dns/log.txt
timer=604800

counter=0
#rm -rf log.txt

while [ $counter -lt $timer ]
do
for dn in  `cat /data/GDS/ping_dns/datanodes.txt`
do
   #   one ping to the current hostname
   ping -c 1 ${dn} > /dev/null 2>&1
   RETVAL=$?
   if [ ${RETVAL} -ne 0 ] ; then
	echo "ping to $dn failed at `date`.." >> /data/GDS/ping_dns/log.txt
   else
	echo "ping to $dn success at `date`..." >> /data/GDS/ping_dns/log.txt
   fi
done
sleep 2
counter=`expr  $counter + 2 `
done
