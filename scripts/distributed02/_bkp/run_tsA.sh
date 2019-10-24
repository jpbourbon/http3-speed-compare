#!/bin/bash

HTTPS=('1.1' '2' '3' '1.1' '2' '3' '1.1' '2' '3')
#A-A- could be removed... but just in case...
DOCKERS='A-A- B-A- C-A- D-A-'
hD="192.168.254.14"
hC="192.168.254.13"
hB="192.168.254.11"

sDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/scripts/distributed01"
#sDIR="go/src/bitbucket.org/jpbourbon/http3-speed-compare/scripts/scenario01/"


function stop_dockers(){
  aux=$1
  for doc in $DOCKERS
  do
    dock="$doc$aux"
    echo "stopping $dock"
    docker stop -t 5 $dock &
    ssh -i ~/debian.pem debian@$hD  dock=$dock 'bash -s ' < dock_stop.sh $dock
    ssh -i ~/debian.pem debian@$hC  dock=$dock 'bash -s ' < dock_stop.sh $dock
    ssh -i ~/debian.pem debian@$hB  dock=$dock 'bash -s ' < dock_stop.sh $dock
  done
}

#just in case...
stop_dockers 1

for sc in ${!HTTPS[@]};
do
  http=${HTTPS[$sc]}
  s=$(($sc+1))

  echo "starting for HTTP/$http  and s=$s"
  #stop_dockers $s
  #sleep 10
  echo "starting msD on $hD"
  echo "  run $sDIR/run_tsA-msD_server.sh $http $s "
  ssh -i ~/debian.pem debian@$hD sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR/run_tsA-msD_server.sh $http $s
  sleep 5
  echo "starting msC on $hC"
  ssh -i ~/debian.pem debian@$hC sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR/run_tsA-msC_server.sh $http $s
  sleep 5
  echo "starting msB on $hB"
  ssh -i ~/debian.pem debian@$hB sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR/run_tsA-msB_server.sh $http $s
  sleep 20
  ./run_tsA-msA_client.sh $http $s
  #
  sleep 30
  stop_dockers $s
  sleep 10
done
echo "Tests finished now collecting results"
cd ../../analysis
#Rscript ./influx_http_speed.R
Rscript ./influx_http_speed-v2.R $1
