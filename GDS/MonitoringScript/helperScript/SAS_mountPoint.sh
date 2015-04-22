#!/bin/sh

echo "Checking Read/Write mode and Count of mount-points"
for i in 67 69 90 91 39 45 
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
