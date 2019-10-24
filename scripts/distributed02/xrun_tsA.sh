#!/bin/bash
DBPASS=http_speed_quic
DBHOST=db.jpbourbon-httpspeed.io
host=msb.jpbourbon-httpspeed.io

HTTPS=('1.1' '2' '3' '1.1' '2' '3' '1.1' '2' '3')
#HTTPS=('3' '1.1' '2' '3' '1.1' '2' '3' '1.1' '2')
DELAY=('10' '10' '10' '10' '10' '10' '10' '10' '10')
SLEEP=('10' '10' '10' '10' '10' '10' '10' '10' '10')
#A-A- could be removed... but just in case...
DOCKERS='A-B- B-B-'


hD="192.168.1.9"
hC="192.168.1.5"
hB="192.168.1.12"

sDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/"
sDIR_SCRIPTS="$sDIR/scripts/distributed02"


function stop_processes(){
  echo "stopping in msB"
  ssh -i ~/debian.pem debian@$hB sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR_SCRIPTS/stop_comparison.sh &

  echo "stopping in msC"
  ssh -i ~/debian.pem debian@$hC sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR_SCRIPTS/stop_comparison.sh &

  echo "stopping in msD"
  ssh -i ~/debian.pem debian@$hD sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR_SCRIPTS/stop_comparison.sh &

  killall comparison
}

stop_processes

sleep 20

echo "starting the process"

for sc in ${!HTTPS[@]};
do
  http=${HTTPS[$sc]}
  s=$(($sc+1))

  echo "starting for HTTP/$http  and scenarion $s"
  #stop_dockers $s
  echo "starting msD"
  #( ./comparison -http $http -ms D -serv 8002 -ts A -s $s & )
  ssh -i ~/debian.pem debian@$hD sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR_SCRIPTS/xrun_tsA-msD-server.sh $http $s $sDIR $hD &
  sleep 1

  echo "starting msC"
  ssh -i ~/debian.pem debian@$hC sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR_SCRIPTS/xrun_tsA-msC-server.sh $http $s $sDIR $hC &
  sleep 1

  echo "starting msB"
  ssh -i ~/debian.pem debian@$hB sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR_SCRIPTS/xrun_tsA-msB-server.sh $http $s $sDIR $hB &
  sleep 1

  echo "starting Client"
  $sDIR/comparison -http $http -ms A -conn 8000 -ts A -s $s -dbpass $DBPASS -dbhost $DBHOST -delay ${DELAY[$sc]} -host $host

  sleep ${SLEEP[$sc]}
  echo "Killing  processes..."
  stop_processes

  sleep 5

done

echo "Tests finished now collecting results"
cd analysis
Rscript ./influx_base_noDocker_http_speed-v3.R $1
