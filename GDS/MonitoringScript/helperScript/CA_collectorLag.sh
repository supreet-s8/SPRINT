for i in 73 

do

	edrflow=`ssh -q root@10.23.80.$i "/opt/tms/bin/cli -t 'en' 'collector stats instance-id 1 adaptor-stats edrflow last-freezed-bin'"`
	edrhttp=`ssh -q root@10.23.80.$i "/opt/tms/bin/cli -t 'en' 'collector stats instance-id 1 adaptor-stats edrhttp last-freezed-bin'"`

	echo "Current Collector lag at Master Namenode"
	echo "========================================"
	echo " "
	curTime=`date +%s`
	
	totalLag_edrflow=`echo $[ $[$edrflow - $curTime]/3600 ]`
	totalLag_edrhttp=`echo $[ $[$edrhttp - $curTime]/3600 ]`
	
echo "Expected Lag should be less than 14 hours"
if [ "$totalLag_edrflow" -lt '-14' ];
then
echo "FAIL : TOTAL Lag edrflow: $totalLag_edrflow"
else
echo "PASS :  EDRFLOW"
fi
echo " "
echo "Expected Lag should be less than 14 hours"
if  [ "$totalLag_edrhttp" -lt '-14' ];
then
echo "FAIL : TOTAL Lag edrhttp: $totalLag_edrhttp"
else
echo "PASS :  EDRHTTP"
fi

done
