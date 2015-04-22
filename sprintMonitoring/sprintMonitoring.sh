#!/bin/bash

/usr/bin/perl /data/offshore_support/sprintMonitoring/screenScriptMonitoring.pl > /data/offshore_support/sprintMonitoring/sprintMonitor.log 2>&1

/usr/bin/perl /data/offshore_support/sprintMonitoring/instaLag.pl >> /data/offshore_support/sprintMonitoring/sprintMonitor.log 2>&1

/usr/bin/perl /data/offshore_support/sprintMonitoring/collectorLag.pl >> /data/offshore_support/sprintMonitoring/sprintMonitor.log 2>&1

/usr/bin/perl /data/offshore_support/sprintMonitoring/hadoop_dfs.pl >> /data/offshore_support/sprintMonitoring/sprintMonitor.log 2>&1

/usr/bin/perl /data/offshore_support/sprintMonitoring/hadoop_mising_corpt.pl >> /data/offshore_support/sprintMonitoring/sprintMonitor.log 2>&1
