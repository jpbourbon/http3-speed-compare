#!/bin/bash
http=$1
s=$2
sDIR=$3
ip=$4
#echo "running comparison with parms=$http, $s at folder $sDIR"
cd $sDIR
#cur=`pwd`
$sDIR/comparison -http $http -ms B -serv 8000  -conn 8001 -ts A -s $s -nameserv msb.jpbourbon-httpspeed.io -host msc.jpbourbon-httpspeed.io -ipserv $ip
