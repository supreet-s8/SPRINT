#!/bin/bash

perl screenScriptMonitoring.pl > sprintMonitor.log 2>&1

perl instaLag.pl >> sprintMonitor.log 2>&1

perl collectorLag.pl >> sprintMonitor.log 2>&1

perl hadoop_dfs.pl >> sprintMonitor.log 2>&1

perl hadoop_mising_corpt.pl >> sprintMonitor.log 2>&1
