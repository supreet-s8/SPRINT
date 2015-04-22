#!/bin/sh
##Script will fetch mail from rubix database Descending Order.



#CNT_1=`ssh -q root@10.23.80.136 "java -jar /opt/tms/nae-spw/WEB-INF/lib/sqltool-2.2.9.3.jar --driver=org.hsqldb.jdbcDriver  --sql='SELECT * FROM CONTACTUS ORDER BY ID DESC;' rubix "|sed 1d|sed 1d |awk '{print $1}'|head -1`

CNT_1=`ssh -q root@10.23.80.136 "java -jar /opt/tms/nae-spw/WEB-INF/lib/sqltool-2.2.9.3.jar --driver=org.hsqldb.jdbcDriver  --sql='SELECT * FROM CONTACTUS  ORDER BY ID DESC;' rubix "|sed 1d|sed 1d |awk '{print $1}'| head -1`

CNT_2=`cat /data/offshore_support/Contact_US/CONTACTUS.txt | head -1`
echo $CNT_2
if [ $CNT_1 -ne $CNT_2 ]

	then
	CNT=`ssh -q root@10.23.80.136 "java -jar /opt/tms/nae-spw/WEB-INF/lib/sqltool-2.2.9.3.jar --driver=org.hsqldb.jdbcDriver  --sql='SELECT * FROM CONTACTUS WHERE ID >'$CNT_2' ORDER BY ID DESC;' rubix "|sed 1d|sed 1d |awk '{print $1}'`
	echo "$CNT" > /data/offshore_support/Contact_US/CONTACTUS.txt
	
	for i in `cat /data/offshore_support/Contact_US/CONTACTUS.txt`
		
		do 
			ssh -q root@10.23.80.136 "java -jar /opt/tms/nae-spw/WEB-INF/lib/sqltool-2.2.9.3.jar --driver=org.hsqldb.jdbcDriver  --sql='SELECT * FROM CONTACTUS WHERE ID ='$i' ORDER BY ID DESC;' rubix " >/data/offshore_support/Contact_US/mail.txt
			USR=`cat /data/offshore_support/Contact_US/mail.txt |sed 1d|sed 1d |awk '{print $4}'`
			echo "$USR"
			USR1=`ssh -q root@10.23.80.136 "java -jar /opt/tms/nae-spw/WEB-INF/lib/sqltool-2.2.9.3.jar --driver=org.hsqldb.jdbcDriver  --sql=\"SELECT EMAIL FROM USER  WHERE USERNAME = '$USR';\" rubix "`	
			echo "$i "
			echo "$USR1"

			SUBJECT=`ssh -q root@10.23.80.136 "java -jar /opt/tms/nae-spw/WEB-INF/lib/sqltool-2.2.9.3.jar --driver=org.hsqldb.jdbcDriver  --sql='SELECT SUBJECT FROM CONTACTUS WHERE ID ='$i';' rubix "`
			BODY=`ssh -q root@10.23.80.136 "java -jar /opt/tms/nae-spw/WEB-INF/lib/sqltool-2.2.9.3.jar --driver=org.hsqldb.jdbcDriver  --sql='SELECT BODY FROM CONTACTUS WHERE ID ='$i';' rubix "`
			echo "$BODY" > /data/offshore_support/Contact_US/mail.txt
cat /data/offshore_support/Contact_US/mail.txt |tr -d \\r |mail   -s "$SUBJECT" -b kevin.keschinger@guavus.com -b samuel.joseph@guavus.com -b erik.maxwell@guavus.com -b mohsin.ali@guavus.com -r "$USR1" NAE_UI_SUPPORT@sprint.com
			sleep 3

done

		else
		echo "no New mail"
fi



		

