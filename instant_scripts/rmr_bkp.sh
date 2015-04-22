#!/bin/sh

## Remove all contents in directory ###

while true
do
	rm -f /data/feeds/collector/lte_2_bkp/*
	rm -f /data/feeds/collector/voice_bkp/*
	rm -f /data/feeds/collector/wimax_bkp/*
	rm -f /data/feeds/collector/ipdr_bkp/*
	rm -f /data/feeds/SMS/*
	sleep 600
done
