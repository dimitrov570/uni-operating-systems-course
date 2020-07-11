
randNr=$((RANDOM % 9 ))
randExit=$((RANDOM % 255));

sleep $randNr

echo "sleep for $randNr and exit with $randExit";
