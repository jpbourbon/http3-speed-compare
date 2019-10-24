http=$1
s=$2
delay_=$3

DBPASS=http_speed_quic
DBHOST=db.jpbourbon-httpspeed.io
host=msb.jpbourbon-httpspeed.io

sDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/"
httpDIR="/home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare/"

  #stop_dockers $s
  #sleep 10
  sleep 1 
  for id in {21..50}
  do
      $sDIR/comparison -http $http -ms A -conn 8000 -ts B -s $s -dbpass $DBPASS -dbhost $DBHOST -delay $delay_ -host $host &
      sleep 0.2
  done
  sleep 20
