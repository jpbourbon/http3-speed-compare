#!/bin/bash
DBPASS=http_speed_quic
DBHOST=db.jpbourbon-httpspeed.io
host=msb.jpbourbon-httpspeed.io

HTTPS=('1.1' '2' '3')
#HTTPS=('3' '1.1' '2')
DELAY=('20' '20' '20')
SLEEP=('10' '10' '10')
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
  sleep 2
  ssh -i ~/debian.pem debian@$hC sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR_SCRIPTS/stop_comparison.sh &

  killall comparison
}

function n_processes(){
  nproc=`pgrep comparison | wc -l`
  echo $nproc
}
stop_processes

stop_processes

sleep 20

for sc in ${!HTTPS[@]};
do
  http=${HTTPS[$sc]}
  s=$(($sc+1))

  echo "starting for HTTP/$http  and scenarion $s"
  #stop_dockers $s
  #sleep 10
  echo "starting msB"
  echo "  run $sDIR/run_tsB-msB_server.sh $http $s "
  ssh -i ~/debian.pem debian@$hB sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR_SCRIPTS/xrun_tsB-msB-server.sh $http $s $sDIR $hB &
  sleep 5
  ssh -i ~/debian.pem debian@$hC sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR_SCRIPTS/xrun_tsB_30_msC.sh $http $s ${DELAY[$sc]}  &

  sleep 5
  for id in {1..20}
  do
       $sDIR/comparison -http $http -ms A -conn 8000 -ts B -s $s -dbpass $DBPASS -dbhost $DBHOST -delay ${DELAY[$sc]} -host $host &
      sleep 0.2
 done

  n_processes
  echo "waiting for processes $nproc"
  while [ "$nproc" -gt 1 ]
  do
    n_processes
    sleep ${SLEEP[$sc]}
  done 
  echo "to stop/kill processes $nproc"
  sleep 30
  stop_processes

  killall comparison

  sleep 2

done

echo "Tests finished now collecting results"
cd analysis
Rscript ./influx_base_noDocker_http_speed-v3.R $1
