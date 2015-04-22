#!/bin/bash

rsync --remove-source-files /data/rise/DPI/*.txt root@10.23.80.73:/data/rise/
rsync --remove-source-files /data/rise/DPI/*.gz root@10.23.80.73:/data/rise/
