#!/bin/bash
DBPASS=http_speed_quic
DBHOST=db.jpbourbon-httpspeed.io

HTTPS=('1.1' '2' '3')
#HTTPS=('3' '1.1' '2')
DELAY=('10' '10' '20')
SLEEP=('10' '10' '10')
#A-A- could be removed... but just in case...
DOCKERS='A-B- B-B-'

hD="192.168.1.9"
hC="192.168.1.5"
hB="192.168.1.12"
hA="192.168.1.7"

sDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/"


function n_processes(){
  nproc=`pgrep comparison | wc -l`
  echo $nproc
}


rm -rf /var/run/httpspeed/comparisonB.pid
rm -rf /var/run/httpspeed/comparisonA-1.pid
rm -rf /var/run/httpspeed/comparisonA-2.pid
rm -rf /var/run/httpspeed/comparisonA-3.pid
rm -rf /var/run/httpspeed/comparisonA-4.pid
for sc in ${!HTTPS[@]};
do
  http=${HTTPS[$sc]}
  s=$(($sc+1))

  echo "starting for HTTP/$http  and scenarion $s"
  sleep 10
  echo "starting msB"
  $sDIR/comparisonB -http $http -ms B -serv 8000 -ts B -s $s -host msb.jpbourbon-httpspeed.io -nameserv msb.jpbourbon-httpspeed.io -ipserv $hA &
  echo $! > /var/run/httpspeed/comparisonB.pid
  sleep 15
  for id in {1..4}
  do
       $sDIR/comparisonA -http $http -ms A -conn 8000 -ts B -s $s -dbpass $DBPASS -dbhost $DBHOST -delay ${DELAY[$sc]} -host msb.jpbourbon-httpspeed.io -ipserv $hA &
       echo $! > /var/run/httpspeed/comparisonA-$id.pid
      sleep 1
  done

  sleep ${SLEEP[$sc]}
  n_processes
  echo "waiting for processes $nproc"
  while [ "$nproc" -gt 1 ]
  do
    n_processes
    sleep 20
  done 
  echo "to stop/kill processes $nproc"
  killall comparisonB
  killall comparisonA

  rm -rf /var/run/httpspeed/comparisonB.pid
  rm -rf /var/run/httpspeed/comparisonA-1.pid
  rm -rf /var/run/httpspeed/comparisonA-2.pid
  rm -rf /var/run/httpspeed/comparisonA-3.pid
  rm -rf /var/run/httpspeed/comparisonA-4.pid

done

echo "Tests finished now collecting results"
cd analysis
#Rscript ./no_influx_http_speed.R
Rscript ./influx_base_noDocker_http_speed-v3.R $1
