#!/bin/bash
link="/data/offshore_support/NSmediate/tree"

find $link -type l -mmin +15 -exec rm -f {} \;

input_dir=/data/feeds/NETSCOUT/

find $input_dir -type f -mmin +15 -exec rm -f {} \;

input_dir1=/data/NetscoutBk/NSretry_email/

find $input_dir1 -type f -mmin +15 -exec rm -f {} \;

input_dir2=/data/NetscoutBk/NSretry_ftp/

input_dir3=/data/NetscoutBk/NSretry_generic/

input_dir4=/data/NetscoutBk/NSretry_http

find $input_dir2 -type f -mmin +15 -exec rm -f {} \;

find $input_dir3 -type f -mmin +15 -exec rm -f {} \;

find $input_dir4 -type f -mmin +15 -exec rm -f {} \;
