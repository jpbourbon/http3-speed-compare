#!/bin/bash
DBPASS=http_speed_quic
DBHOST=db.jpbourbon-httpspeed.io

HTTPS=('1.1' '2' '3' '1.1' '2' '3' '1.1' '2' '3')
#HTTPS=('3' '1.1' '2' '3' '1.1' '2' '3' '1.1' '2')
DELAY=('20s' '20s' '20s' '20s' '20s' '20s' '20s' '20s' '20s')
SLEEP=('10' '10' '10' '10' '10' '10' '10' '10' '10')
#A-A- could be removed... but just in case...
DOCKERS='A-B- B-B-'

rm -rf /var/run/httpspeed/comparisonD.pid
rm -rf /var/run/httpspeed/comparisonB.pid
rm -rf /var/run/httpspeed/comparisonC.pid
rm -rf /var/run/httpspeed/comparisonA.pid


hD="192.168.1.9"
hC="192.168.1.5"
hB="192.168.1.12"
hA="192.168.1.7"

sDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/"

for sc in ${!HTTPS[@]};
do
  http=${HTTPS[$sc]}
  s=$(($sc+1))

  echo "starting for HTTP/$http  and scenarion $s"
  #stop_dockers $s
  sleep 1
  echo "starting msD"
  $sDIR/comparisonD -http $http -ms D -serv 8002 -ts A -s $s -host msd.jpbourbon-httpspeed.io -nameserv msd.jpbourbon-httpspeed.io -ipserv $hA &
  echo $! > /var/run/httpspeed/comparisonD.pid
  sleep 1
  echo "starting msC"
  $sDIR/comparisonC -http $http -ms C -serv 8001 -conn 8002 -ts A -s $s -host msd.jpbourbon-httpspeed.io -nameserv msc.jpbourbon-httpspeed.io -ipserv $hA &
  echo $! > /var/run/httpspeed/comparisonC.pid
  sleep 1
  echo "starting msB"
  $sDIR/comparisonB -http $http -ms B -serv 8000 -conn 8001 -ts A -s $s -host msc.jpbourbon-httpspeed.io -nameserv msb.jpbourbon-httpspeed.io -ipserv $hA &
  echo $! > /var/run/httpspeed/comparisonB.pid
  sleep 1
  echo "starting Client"
  $sDIR/comparisonA -http $http -ms A -conn 8000 -ts A -s $s -dbpass $DBPASS -dbhost $DBHOST -delay ${DELAY[$sc]} -host msb.jpbourbon-httpspeed.io
  echo $! > /var/run/httpspeed/comparisonA.pid

  sleep ${SLEEP[$sc]}
  echo "Killing  processes..."
  killall comparisonD
  killall comparisonC
  killall comparisonB
  killall comparisonA

  rm -rf /var/run/httpspeed/comparisonD.pid
  rm -rf /var/run/httpspeed/comparisonB.pid
  rm -rf /var/run/httpspeed/comparisonC.pid
  rm -rf /var/run/httpspeed/comparisonA.pid

done

echo "Tests finished now collecting results"
cd analysis
Rscript ./influx_base_noDocker_http_speed-v3.R $1
