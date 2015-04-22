#!/bin/bash

while true
do
        
        ls /data/feeds/DPI/*.gz | while read file
        do
                rm $file
        done

        find /data/feeds/CIBER -name "*MSID*" -type f -exec rm {} \;
        find /data/feeds/CIBER -name "*MSC*" -type f -exec rm {} \;
        find /data/feeds/CIBER -name "*FARCHMDSMS*" -type f -exec rm {} \;
        find /data/feeds/CIBER -name "*FARCHIVE*" -type f -exec rm {} \;

    #Added by V. Stockdale 6/20/2013
    #V Stockdale Changed /tmp to /data/NetscoutBk/ to reduce disk usage in /var/ on 10/22/2013
        #Edited by A. Mildenstein 2013-09-04; Added --retrydir directive
        #Edited by A. Mildenstein 2013-09-10; Removed --debug flag

/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.18 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.11.116 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.18 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.56 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.18 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.68 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.18 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.24 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.18 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.0 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.41 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.26.56 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.41 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.60 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.124 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.41 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.64 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.18 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.6.120 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.48 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.8 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.41 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.28 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.41 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.4 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.32 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.11.20 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.112 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.120 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.14.56 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.80 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.36 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.72 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.42 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.20 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.48 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.76 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.48 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.2.120 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.48 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.2.56 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.48 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.26.120 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.48 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.16 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.48 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.12 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &
/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.48  --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.116 --excludestring='DIAMETER|DNS|FTP_CONTROL|RADIUS_ACCESS|RADIUS_ACCT|GTPv2|MEDIA|PMIPV6|S1AP|S1MME|SIP|HTTPS|LDAP|GCSNA|S102' &                                                                                                                                                                                 
#### Added the following lines to support LTE to EAP project 
#/data/offshore_support/NSmediate/NSmediate_new.py --user=guavsftp --host=144.226.248.116 --localdir=/data/feeds/NETSCOUT/   --remotedir=/logs/lph/incoming/guavus/lte_dpi_email/ --includestr="EMAIL"    --excludestr='FTP_DATA|GENERIC|FTP|FTP_CONTROL|HTTP|DIAMETER|DNS|PMIP|S1AP|S1MME' &
#/data/offshore_support/NSmediate/NSmediate_new.py --user=guavsftp --host=144.226.248.116 --localdir=/data/feeds/NETSCOUT/   --remotedir=/logs/lph/incoming/guavus/lte_dpi_ftp_data/  --includestr="FTP_DATA" --excludestr='GENERIC|EMAIL|FTP_CONTROL|HTTP|DIAMETER|DNS|PMIP |S1AP|S1MME' &
#/data/offshore_support/NSmediate/NSmediate_new.py --user=guavsftp --host=144.226.248.116 --localdir=/data/feeds/NETSCOUT/   --remotedir=/logs/lph/incoming/guavus/lte_dpi_generic/   --includestr="GENERIC"  --excludestr='FTP_DATA|EMAIL|FTP|FTP_CONTROL|HTTP|DIAMETER|DNS|PMIPg|S1AP|S1MME' &
#/data/offshore_support/NSmediate/NSmediate_new.py --user=guavsftp --host=144.226.248.116 --localdir=/data/feeds/NETSCOUT/   --remotedir=/logs/lph/incoming/guavus/lte_dpi_http/  --includestr="HTTP" --excludestr='FTP_DATA|GENERIC|FTP|FTP_CONTROL|EMAIL|DIAMETER|DNS|PMIP|S1AP|S1MME' &

/var/home/root/netscout_sftp/NSmediate.py       --user  guavsftp        --host  144.226.248.116 --localdir      /data/feeds/NETSCOUT/   --remotedir     /logs/lph/incoming/guavus/lte_dpi_email/       --includestr "EMAIL"    --excludestr "FTP_DATA" --excludestr "GENERIC" --excludestr "FTP" --excludestr "FTP_CONTROL" --excludestr "HTTP" --excludestr "DIAMETER" --excludestr "DNS" --excludestr "PMIP"  --excludestr "S1AP" --excludestr "S1MME" --retrydir /data/NetscoutBk/NSretry_email        -l /data/netscout_log/netscout.EAP.email.log --lockfile /data/NetscoutBk/NSmediate_EAP.email.lck &
/var/home/root/netscout_sftp/NSmediate.py       --user  guavsftp        --host  144.226.248.116 --localdir      /data/feeds/NETSCOUT/   --remotedir     /logs/lph/incoming/guavus/lte_dpi_ftp_data/    --includestr "FTP_DATA" --excludestr "GENERIC" --excludestr "EMAIL" --excludestr "FTP_CONTROL" --excludestr "HTTP" --excludestr "DIAMETER" --excludestr "DNS" --excludestr "PMIP"  --excludestr "S1AP" --excludestr "S1MME" --retrydir /data/NetscoutBk/NSretry_ftp        -l /data/netscout_log/netscout.EAP.ftp.log --lockfile /data/NetscoutBk/NSmediate_EAP.ftp.lck &
/var/home/root/netscout_sftp/NSmediate.py       --user  guavsftp        --host  144.226.248.116 --localdir      /data/feeds/NETSCOUT/   --remotedir     /logs/lph/incoming/guavus/lte_dpi_generic/     --includestr "GENERIC"  --excludestr "FTP_DATA" --excludestr "EMAIL" --excludestr "FTP" --excludestr "FTP_CONTROL" --excludestr "HTTP" --excludestr "DIAMETER" --excludestr "DNS" --excludestr "PMIP"  --excludestr "S1AP" --excludestr "S1MME" --retrydir /data/NetscoutBk/NSretry_generic        -l /data/netscout_log/netscout.EAP.generic.log --lockfile /data/NetscoutBk/NSmediate_EAP.generic.lck &
/var/home/root/netscout_sftp/NSmediate.py       --user  guavsftp        --host  144.226.248.116 --localdir      /data/feeds/NETSCOUT/   --remotedir     /logs/lph/incoming/guavus/lte_dpi_http/                --includestr "HTTP"     --excludestr "FTP_DATA" --excludestr "GENERIC" --excludestr "FTP" --excludestr "FTP_CONTROL" --excludestr "EMAIL" --excludestr "DIAMETER" --excludestr "DNS" --excludestr "PMIP"  --excludestr "S1AP" --excludestr "S1MME" --retrydir /data/NetscoutBk/NSretry_http        -l /data/netscout_log/netscout.EAP.http.log --lockfile /data/NetscoutBk/NSmediate_EAP.http.lck &
#
#### Added the following line to support the SevenFlow PoC
#/data/offshore_support/NSmediate/file_copy.sh --user=sevenflow --host=10.23.80.253 --localdir=/data/feeds/NETSCOUT/ --remotedir=/opt/sevenflow/collector/netscout-repository/ready/ --includeip=10 --includestring="GTPv2_CONTROL" &

## COPY DATA TO 80.26

#/data/offshore_support/NSmediate/file_copy.sh --user=root --host=10.23.80.26 --localdir=/data/feeds/NETSCOUT/ --remotedir=/usr/local/Calpont/data1/GDS/NetScout_Sept/ --includeip=10.32.8.6 --includestring="HTTP" &
#
####
### To take backup of netscout feeds ##########
#/data/offshore_support/NSmediate/file_copy.sh --user=root --host=10.23.80.4 --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/live_feeds/Copy_of_Netscout/  --includeip=10



#### Don't background the last one!!!
####
#/data/offshore_support/NSmediate/file_copy.sh --user=guav_qus --host=144.226.255.48  --localdir=/data/feeds/NETSCOUT/ --remotedir=/data/mapper/incoming/qus/lte_dpi --includeip=10.32.116 &
#        
## Commented this out!  It's easier to run all of these NSmediate.py jobs in parallel and have them delete after they're done.
## A. Mildenstein, 20130904
##       find /data/feeds/NETSCOUT/ -type f -exec rm {} \; 
## Replaced the above find/rm with this:
## A. Mildenstein, 20130904.  This script will not delete ANY NETSCOUT/ file excluded by the list in it (hardcoded for now).

        /data/offshore_support/NSmediate/clean_up.sh
#
        sleep 300
done
#
