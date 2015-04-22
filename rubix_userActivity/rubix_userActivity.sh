#!/bin/sh

DATE=`date`;

ssh -q root@10.23.80.6 "/usr/bin/perl  /data/offshore_support/rubix_user_details.pl 28" > /data/offshore_support/rubix_userActivity/user_log.csv

sleep 2;


echo "User login audit report on $DATE" | mail -a /data/offshore_support/rubix_userActivity/user_log.csv -s "Rubix/UI Users" -r Sprint_production-admin@guavus.com kevin.keschinger@guavus.com Samuel.Joseph@guavus.com robert.phillips@guavus.com mohsin.ali@guavus.com eric.darby@guavus.com jatinder.singh@guavus.com
