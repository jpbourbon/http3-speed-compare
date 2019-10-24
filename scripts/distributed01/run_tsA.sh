#!/bin/bash

#HTTPS=('3' '3' '3')
HTTPS=('1.1' '2' '3' '1.1' '2' '3' '1.1' '2' '3')
#HTTPS=('3' '1.1' '2' '3' '1.1' '2' '3' '1.1' '2')
#A-A- could be removed... but just in case...
DOCKERS='A-A- B-A- C-A- D-A-'

hD="192.168.1.9"
hC="192.168.1.5"
hB="192.168.1.12"

sDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/scripts/distributed01"
httpDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/"

#sDIR="go/src/bitbucket.org/jpbourbon/http3-speed-compare/scripts/scenario01/"

function stop_dockers(){
  aux=$1
  for doc in $DOCKERS
  do
    dock="$doc$aux"
    echo "stopping $dock"
    docker stop -t 5 $dock &
    ssh -i ~/debian.pem debian@$hD  dock=$dock 'bash -s ' < $sDIR/dock_stop.sh $dock &
    ssh -i ~/debian.pem debian@$hC  dock=$dock 'bash -s ' < $sDIR/dock_stop.sh $dock &
    ssh -i ~/debian.pem debian@$hB  dock=$dock 'bash -s ' < $sDIR/dock_stop.sh $dock &
  done
}

#just in case...
stop_dockers 1

sleep 2

for sc in ${!HTTPS[@]};
do
  http=${HTTPS[$sc]}
  s=$(($sc+1))

  echo "starting for HTTP/$http  and s=$s"
  #stop_dockers $s
  #sleep 10
  echo "starting msD on $hD"
  echo "  run $sDIR/run_tsA-msD_server.sh $http $s "
  if [ $http == '3' ]
  then
  ssh -i ~/debian.pem debian@$hD sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR/run_tsA-msD_server_udp.sh $http $s &
  else
  ssh -i ~/debian.pem debian@$hD sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR/run_tsA-msD_server.sh $http $s &
  fi
  sleep 3

  echo "starting msC on $hC"
  if [ $http == '3' ]
  then
  ssh -i ~/debian.pem debian@$hC sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR/run_tsA-msC_server_udp.sh $http $s &
  else
  ssh -i ~/debian.pem debian@$hC sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR/run_tsA-msC_server.sh $http $s &
  fi
  sleep 3

  echo "starting msB on $hB"
  if [ $http == '3' ]
  then
  ssh -i ~/debian.pem debian@$hB sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR/run_tsA-msB_server_udp.sh $http $s &
  else
  ssh -i ~/debian.pem debian@$hB sDIR=$sDIR http=$http s=$s 'bash -s ' < $sDIR/run_tsA-msB_server.sh $http $s &
  fi

  sleep 15
  $sDIR/run_tsA-msA_client.sh $http $s
  #
  sleep 15
  stop_dockers $s
  sleep 8
done

echo "Tests finished now collecting results"
cd $httpDIR/analysis
Rscript ./influx_http_speed-v2.R $1
