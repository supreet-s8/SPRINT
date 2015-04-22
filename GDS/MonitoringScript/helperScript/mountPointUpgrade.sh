#!/bin/sh

#removed node 6 and 7 based on discussion with Jasmeet.

for i in 4 5 10 11 12 13 14 15 16 17 18 19 20 21  
do
        echo " "
      mount=`ssh -q root@10.23.80.$i "/bin/mount | grep '/dev/mapper'" | grep -iw  "rw"|wc -l `
if [[ "$mount" -eq '0' ]]
then
	echo "Node - 10.23.80.$i    FAIL, read-only mode"
else
	echo "Node - 10.23.80.$i    PASS  Count :$mount"
fi
done
