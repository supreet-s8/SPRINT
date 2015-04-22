for i in 11

do

	cdmaIpdr=`ssh -q root@10.23.80.$i "/opt/tms/bin/cli -t 'en' 'collector stats instance-id 1 adaptor-stats cdmaIpdr last-freezed-bin'"`
	cdmaVoice=`ssh -q root@10.23.80.$i "/opt/tms/bin/cli -t 'en' 'collector stats instance-id 1 adaptor-stats cdmaVoice last-freezed-bin'"`
	lteIpdr=`ssh -q root@10.23.80.$i "/opt/tms/bin/cli -t 'en' 'collector stats instance-id 1 adaptor-stats lteIpdr last-freezed-bin'"`
	wimax=`ssh -q root@10.23.80.$i "/opt/tms/bin/cli -t 'en' 'collector stats instance-id 1 adaptor-stats wimax last-freezed-bin'"`

	echo "Current Collector lag at Master Namenode"
	echo "========================================"
	echo " "
	curTime=`date +%s`
	
	totalLag_cdmaIpdr=`echo $[ $[$cdmaIpdr - $curTime]/3600 ]`
	#totalLag_cdmaSms=`echo $[ $[$cdmaSms - $curTime]/3600 ]`
	totalLag_cdmaVoice=`echo $[ $[$cdmaVoice - $curTime]/3600 ]`
	totalLag_lteIpdr=`echo $[ $[$lteIpdr - $curTime]/3600 ]`
	totalLag_wimax=`echo $[ $[$wimax - $curTime]/3600 ]`
	
echo "Expected Lag should be less than 14 hours"
if [ "$totalLag_cdmaIpdr" -lt '-14' ];
then 
echo "FAIL : TOTAL Lag cdmaIpdr: $totalLag_cdmaIpdr"
else
echo "PASS :  cdmaIPDR"
fi
echo " "
echo "Expected Lag should be less than 18 hours"
if [ "$totalLag_cdmaVoice" -lt '-18' ];
then
echo "FAIL : TOTAL Lag cdmaVoice: $totalLag_cdmaVoice"
else
echo "PASS :  cdmaVOICE"
fi
echo " "
echo "Expected Lag should be less than 14 hours"
if [ "$totalLag_lteIpdr" -lt '-14' ];
then
echo "FAIL : TOTAL Lag lteIpdr: $totalLag_lteIpdr"
else
echo "PASS :  LTE"
fi
echo " "
echo "Expected Lag should be less than 14 hours"
if  [ "$totalLag_wimax" -lt '-14' ];
then
echo "FAIL : TOTAL Lag wimax: $totalLag_wimax"
else
echo "PASS :  WIMAX"
fi




done
