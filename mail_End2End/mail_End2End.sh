fileName=`ssh -q root@10.23.80.70 "ls -lrt /data/offshore_support/GDS/MonitoringScript/Monitoring_Output | tail -1" | awk '{print $NF}'`;scp root@10.23.80.70:/data/offshore_support/GDS/MonitoringScript/Monitoring_Output/$fileName /data/offshore_support/GDS/End2End/;echo "Please see attached End2End health report" |mail -s "Latest SPRINT End2End report" -a /data/offshore_support/GDS/End2End/`ls -lrt /data/offshore_support/GDS/End2End/ |tail -1 |awk '{print $NF}'` -r  Sprint_production.monitoring@guavus.com          jatinder.singh@guavus.com samuel.joseph@guavus.com robert.phillips@guavus.com eric.darby@guavus.com mohsin.ali@guavus.com manish.sharma@guavus.com vishal.gupta@guavus.com  anubhav.srivastav@guavus.com ahsan.javed@guavus.com  shailendra.kumar@guavus.com gaurav.babbar@guavus.com

sleep 10

echo "`ssh -q root@10.23.80.4 "sh /data/offshore_support/job_monitor.sh"`" |mail -s Job_Monitoring -r sprint.production.monitoring@guavus.com mohsin.ali@guavus.com   jatinder.singh@guavus.com samuel.joseph@guavus.com  shailendra.kumar@guavus.com  gaurav.babbar@guavus.com 



##This report is not required as it was created during LTE lag
#fileName1=`ssh -q root@10.23.80.70 "ls -lrt /data/offshore_support/GDS/MonitoringScript/daily_Output | tail -1" | awk '{print $NF}'`;scp root@10.23.80.70:/data/offshore_support/GDS/MonitoringScript/daily_Output/$fileName1 /data/offshore_support/GDS/daily_Output/;echo "Please see attached daily report" |mail -s "Latest SPRINT daily report" -a /data/offshore_support/GDS/daily_Output/`ls -lrt /data/offshore_support/GDS/daily_Output/ |tail -1 |awk '{print $NF}'` -r  Sprint_production.monitoring@guavus.com          jatinder.singh@guavus.com samuel.joseph@guavus.com robert.phillips@guavus.com eric.darby@guavus.com mohsin.ali@guavus.com manish.sharma@guavus.com vishal.gupta@guavus.com  manpreet.singh@guavus.com  anubhav.srivastav@guavus.com ahsan.javed@guavus.com  kevin.keschinger@guavus.com  shailendra.kumar@guavus.com gaurav.babbar@guavus.com
