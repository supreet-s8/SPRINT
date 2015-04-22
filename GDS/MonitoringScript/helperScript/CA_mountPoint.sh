#!/bin/sh

echo "Checking Read/Write mode and Count of mount-points"
for i in 71 72 74 75 77 78 80 81 40 41 43 44 46 48 49 55 54 53 50 59 58 62 63 60 61 66 68 64 99 100 
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
