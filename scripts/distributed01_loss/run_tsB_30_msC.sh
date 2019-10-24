http=$1
s=$2


sDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/scripts/distributed01_loss"
httpDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/"

  #stop_dockers $s
  #sleep 10
  sleep 1 
  for id in {21..50}
  do
      $sDIR/run_tsB-msA_client.sh $http $s $id &
  done
  sleep 20
