#!/bin/bash
http=$1
s=$2
sDIR=$3
ip=$4
#echo "running comparison with parms=$http, $s at folder $sDIR"
cd $sDIR
#cur=`pwd`
#echo "at folder $cur"
#( ./comparison -http $http -ms D -serv 8002 -ts A -s $s & )
$sDIR/comparison -http $http -ms D -serv 8002  -ts A -s $s -nameserv msd.jpbourbon-httpspeed.io -host msd.jpbourbon-httpspeed.io -ipserv $ip
