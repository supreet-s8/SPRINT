#!/bin/bash

/var/home/root/netscout_sftp/NSmediate.py	--user	guav_qus	--host	144.226.255.18	--localdir	/data/feeds/NETSCOUT/	--remotedir	/data/mapper/incoming/qus/lte_dpi	--includeip	10.11.116.  --retrydir /tmp/NSretry_10.11.116	--debug -l /data/netscout_log/netscout.10.11.116.log &
