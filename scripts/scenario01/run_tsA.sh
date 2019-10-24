#!/bin/bash

HTTPS=('1.1' '2' '3' '1.1' '2' '3' '1.1' '2' '3')
#A-A- could be removed... but just in case...
DOCKERS='A-A- B-A- C-A- D-A-'

function stop_dockers(){
  aux=$1
  for doc in $DOCKERS
  do
    dock="$doc$aux"
    echo "stopping $dock"
    docker stop -t 5 $dock
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
  echo "starting msD"
  ./run_tsA-msD_server.sh $http $s
  sleep 5
  echo "starting msC"
  ./run_tsA-msC_server.sh $http $s
  sleep 5
  echo "starting msB"
  ./run_tsA-msB_server.sh $http $s
  sleep 5
  ./run_tsA-msA_client.sh $http $s
  #
  sleep 30
  stop_dockers $s
done
echo "Tests finished now collecting results"
cd ../../analysis
#Rscript ./influx_http_speed.R
Rscript ./influx_http_speed-v2.R $1
