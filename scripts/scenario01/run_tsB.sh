#!/bin/bash

HTTPS=('1.1' '2' '3')
#HTTPS=('3' '2')
#A-A- could be removed... but just in case...
DOCKERS='A-B- B-B-'

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

  echo "starting for HTTP/$http  and scenarion $s"
  #stop_dockers $s
  #sleep 10
  echo "starting msB"
  ./run_tsB-msB_server.sh $http $s
  sleep 5
  for id in {1..4}
  do
      ( ./run_tsB-msA_client.sh $http $s $id & )
  done
  sleep 120
  stop_dockers $s
done
echo "Tests finished now collecting results"
cd ../../analysis
Rscript ./influx_http_speed-v2.R $1
