python /data/offshore_support/Stats_NAE/NAE_createFile.py
fileName=`ls -lrt /data/offshore_support/DailyStatNAE |tail -1 | awk '{print $NF}'`
echo $fileName
python /data/offshore_support/Stats_NAE/NAE_collector_stats.py >> /data/offshore_support/DailyStatNAE/$fileName
