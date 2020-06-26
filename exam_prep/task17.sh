#!/bin/bash

if [ $# -ne 1 ]; then
		exit 1;
fi

if [ $(id -u) -ne 0 ]; then
		exit 0;
fi

nrOfProc=$(ps -u "$1" | wc -l)

users=$(ps -e -o user= | sort | uniq)

while read uName; do
	nr=$(ps -u "${uName}" | wc -l);

	if [ ${nr} -gt ${nrOfProc} ]; then
			echo $uName;
	fi

done < <(echo -e "${users}")


echo "------------------------------------------------------------------------"
echo "----------------------------AVERAGE TIME--------------------------------"
echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"

times=$(ps -e -o time=)
nr=$(echo -e "$times" | wc -l)
result=0

while read time; do
		hrs=$(echo $time | cut -d ':' -f 1 | sed -E "s/^0+([^0]+[0-9]*)/\1/");
		mins=$(echo $time | cut -d ':' -f 2 | sed -E "s/^0+([^0]+[0-9]*)/\1/");
		secs=$(echo $time | cut -d ':' -f 3 | sed -E "s/^0+([^0]+[0-9]*)/\1/");
		result=$(($result + $hrs * 3600));
		result=$(($result + $mins * 60));
		result=$(($result + $secs));
done < <(echo -e "$times")
AVG=$(bc -l < <(echo "$result / $nr"));
echo $AVG


echo "------------------------------------------------------------------------"
echo "------------------------------------------------------------------------"

while read p_pid p_time; do
		result=0;
		hrs=$(echo $p_time | cut -d ':' -f 1 | sed -E "s/^0+([^0]+[0-9]*)/\1/");
		mins=$(echo $p_time | cut -d ':' -f 2 | sed -E "s/^0+([^0]+[0-9]*)/\1/");
		secs=$(echo $p_time | cut -d ':' -f 3 | sed -E "s/^0+([^0]+[0-9]*)/\1/");
		result=$(($result + $hrs * 3600));
		result=$(($result + $mins * 60));
		result=$(($result + $secs));		
		if [ $(echo "$result>($AVG * 2)" | bc) -eq 1 ]; then
				echo $p_time $result $p_pid;
				#kill -s TERM $p_pid
				#sleep 1
				#kill -s KILL $p_pid
		fi

done < <(ps -u $1 -o pid=,time=)
