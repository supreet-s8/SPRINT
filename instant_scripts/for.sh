for p in 2014
do
 for i in `hadoop dfs -du /data/collector/output 2>/dev/null|grep lte |awk -F "vip:9000" '{print $NF}'`
	do
		for j in  12
			do
				for k in `seq -w 11 31`
					do
					for l in `seq -w 00 23`
					do
					  hadoop dfs -du $i/${p}/${j}/${k}/${l} 2>/dev/null|awk '{if($1 !~ /DONE/) print $0}'|awk '{if($1 !~ /\./) print $0}'|awk '{if($1 != 0) print $0}'|awk -F / '{sum+=$1}END{print sum " " "/"$4"/"$5"/"$6"/"$7"/"$8"/"$9"/"$10"/"$11}'
					  hadoop dfs -lsr $i/${p}/${j}/${k}/$l 2>/dev/null |awk '{if($1 !~ /DONE/) print $0}'|grep _DONE|awk '{print $NF}' 
				done
			done
		done
	done
done	
